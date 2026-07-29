{ pkgs, ... }:

let
  email = "p.kosel@tuta.io";

  # Public half of the key gcr-ssh-agent already holds, so signing needs no
  # private material and no passphrase prompt.
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgPnFNx3Xh/s2AaPlfND+jpypNf4h1mD8BZyGiK0dAF";

  # Who git will trust when verifying. Without it signing still works but
  # `git log --show-signature` cannot check anything.
  allowedSigners = pkgs.writeText "allowed_signers" ''
    ${email} namespaces="git" ${signingKey}
  '';
in
{
  programs.git = {
    enable = true;

    signing = {
      format = "ssh";
      # key:: takes the key inline, so nothing depends on a path outside the store.
      key = "key::${signingKey}";
      signByDefault = true;
    };

    ignores = [ "**/.claude/settings.local.json" ];

    settings = {
      user = {
        name = "Philipp Kosel";
        inherit email;
      };
      init = {
        defaultBranch = "main";
      };
      gpg.ssh.allowedSignersFile = toString allowedSigners;

      push.autoSetupRemote = true;
      fetch.prune = true;
      # Linear history; nobody else pushes here.
      pull.rebase = true;
      diff.algorithm = "histogram";
      # zdiff3 puts the common ancestor in the conflict markers.
      merge.conflictStyle = "zdiff3";
      # Diff in the commit editor, so the message describes what is staged.
      commit.verbose = true;
    };
  };
}
