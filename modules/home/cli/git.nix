{ pkgs, ... }:

let
  email = "170943+pkosel@users.noreply.github.com";

  # Signing requires the matching private key in GNOME's SSH agent.
  signingPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgPnFNx3Xh/s2AaPlfND+jpypNf4h1mD8BZyGiK0dAF";

  # SSH verification requires an explicit allowlist of trusted signing keys.
  allowedSignersFile = pkgs.writeText "allowed_signers" ''
    ${email} namespaces="git" ${signingPublicKey}
  '';
in
{
  programs.git = {
    enable = true;

    signing = {
      format = "ssh";
      key = "key::${signingPublicKey}";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Philipp Kosel";
        inherit email;
      };
      init = {
        defaultBranch = "main";
      };
      gpg.ssh.allowedSignersFile = toString allowedSignersFile;

      push.autoSetupRemote = true;
      fetch.prune = true;
      pull.ff = "only";
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
      merge = {
        conflictStyle = "zdiff3";
        tool = "nvimdiff";
      };
      commit.verbose = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
    };
  };
}
