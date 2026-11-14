{ pkgs, ... }:

let
  email = "git@pkosel.dev";

  # Signing requires the matching private key in GNOME's SSH agent.
  signingPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSSLqnBtA6WHXds7TADlPvaUW13HGXyqCINYUgWmZ0c";

  # SSH verification needs an explicit allowlist; retain the previous email for
  # historical commits signed by this key.
  allowedSignersFile = pkgs.writeText "allowed_signers" ''
    ${email},170943+pkosel@users.noreply.github.com namespaces="git" ${signingPublicKey}
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
