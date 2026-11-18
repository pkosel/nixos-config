#!/usr/bin/env bash
set -euo pipefail

action=$1
stage=$2
shift 2
parent=${stage%/*}

case "$action" in
  prepare|cleanup) ;;
  *) echo 'Expected prepare or cleanup for Bridget backup staging.' >&2; exit 1 ;;
esac
if [[ ! -d $parent || -L $parent || $(stat -c '%a:%u:%g' -- "$parent" 2>/dev/null) != "700:$EUID:$(id -g)" ]]; then
  echo 'Bridget backup staging parent is not private or is missing.' >&2
  exit 1
fi

# Staging is scratch space, including after an interrupted run.
if ! rm -rf --one-file-system --preserve-root=all -- "$stage" 2>/dev/null; then
  echo 'Could not clear Bridget backup staging.' >&2
  exit 1
fi
if [[ $action == cleanup ]]; then
  exit 0
fi
if ! mkdir -m 0700 -- "$stage" 2>/dev/null; then
  echo 'Could not create Bridget backup staging.' >&2
  exit 1
fi

running=()
for unit in freshrss-updater.timer forgejo.service authelia-main.service phpfpm-freshrss.service papra.service; do
  state=$(systemctl show --property=ActiveState --value "$unit")
  case "$state" in
    active) running+=("$unit") ;;
    inactive|failed) ;;
    *) printf 'Cannot pause %s for backup while it is %s.\n' "$unit" "$state" >&2; exit 1 ;;
  esac
done

resume_services() {
  local capture_status=$? resume_status=0
  if (( ${#running[@]} )); then
    systemctl start "${running[@]}" || resume_status=$?
  fi
  if (( resume_status != 0 )); then
    printf 'Resuming Bridget backup services failed (systemctl exit %d).\n' "$resume_status" >&2
  fi
  if (( capture_status != 0 )); then
    exit "$capture_status"
  fi
  exit "$resume_status"
}

copy_state() {
  local source=$1 name=$2 status=0
  # rsync errors may include names of private repositories or documents.
  rsync -a -- "$source/" "$stage/$name/" >/dev/null 2>&1 || status=$?
  if (( status != 0 )); then
    printf 'Copying %s into Bridget backup staging failed (rsync exit %d).\n' "$name" "$status" >&2
  fi
  return "$status"
}

# Copy stopped applications locally, then restart before the network upload.
trap resume_services EXIT
if (( ${#running[@]} )); then
  systemctl stop "${running[@]}"
fi
# Stop the updater after its timer is paused; do not replay it on resume.
systemctl stop freshrss-updater.service
copy_state "$1" forgejo
copy_state "$2" authelia-main
copy_state "$3" freshrss
copy_state "$4" papra
copy_state "$5" papra-inbox
copy_state "$6" papra-sftp
