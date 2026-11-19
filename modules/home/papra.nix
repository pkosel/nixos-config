{ ... }:

{
  gtk.gtk3.bookmarks = [
    "sftp://papra-inbox/inbox Papra inbox"
  ];

  programs.ssh.settings.papra-inbox = {
    User = "papra-upload";
    # Provision this key locally; GCR can remember its passphrase.
    IdentityFile = "~/.ssh/papra-inbox";
    IdentitiesOnly = true;
    AddKeysToAgent = "yes";
  };
}
