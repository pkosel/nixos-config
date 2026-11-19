{ ... }:

{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;

      # The override sets a schema default, so the GNOME Settings switch
      # still works. dconf.settings would reapply on every activation.
      extraGSettingsOverrides = ''
        [org.gnome.desktop.interface]
        color-scheme='prefer-dark'
      '';
    };
  };
}
