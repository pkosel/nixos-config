{ ... }:

{
  programs.ssh = {
    enable = true;

    # Off: it re-asserts OpenSSH's pre-9 defaults over the current ones, and
    # home-manager plans to deprecate it.
    enableDefaultConfig = false;

    # Personal hosts go in ~/.ssh/config.local, which stays off the repo.
    # Emitted first, and ssh takes the first value it obtains, so anything
    # there wins over the block below.
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
