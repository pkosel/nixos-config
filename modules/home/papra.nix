{ ... }:

{
  gtk.gtk3.bookmarks = [
    "sftp://papra-inbox/inbox Papra inbox"
  ];

  programs.ssh.settings.papra-inbox = {
    HostName = "46.225.15.126";
    User = "papra-upload";
    # Provision this key locally; GCR can remember its passphrase.
    IdentityFile = "~/.ssh/papra-inbox";
    IdentitiesOnly = true;
    AddKeysToAgent = "yes";
    StrictHostKeyChecking = "yes";
  };
}
