{ ... }:

{
  programs.ssh = {
    enable = true;

    # Off: it re-asserts OpenSSH's pre-9 defaults over the current ones, and
    # home-manager plans to deprecate it.
    enableDefaultConfig = false;

    # SSH uses the first obtained value, so the untracked config.local overrides
    # the defaults below.
    includes = [ "config.local" ];

    settings."*" = {
      # Reuse one connection, so a fetch and a push cost a single handshake.
      # Kept short: a master left over a suspend hangs the next command until
      # it times out.
      ControlMaster = "auto";
      ControlPath = "~/.ssh/master-%C";
      ControlPersist = "1m";
    };
  };
}
