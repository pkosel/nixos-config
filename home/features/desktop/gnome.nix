{ inputs, outputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-panel
    gnomeExtensions.pop-shell
    window-resizer
  ];

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "dash-to-panel@jderose9.github.com"
        "pop-shell@system76.com"
        "window-resizer@pkosel.github.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "zotero-6.0.26.desktop"
        "obsidian.desktop"
      ];
    };
    "org/gnome/shell/extensions/dash-to-panel" = {
      dot-style-focused = "SQUARES";
      dot-style-unfocused = "SQUARES";
      stockgs-keep-top-panel = true;
      panel-element-positions = ''
        {"0":[
          {"element":"showAppsButton","visible":true,"position":"stackedBR"},
          {"element":"activitiesButton","visible":false,"position":"stackedTL"},
          {"element":"leftBox","visible":false,"position":"stackedTL"},
          {"element":"taskbar","visible":true,"position":"centered"},
          {"element":"centerBox","visible":false,"position":"stackedBR"},
          {"element":"rightBox","visible":false,"position":"stackedBR"},
          {"element":"dateMenu","visible":false,"position":"stackedBR"},
          {"element":"systemMenu","visible":false,"position":"stackedBR"},
          {"element":"desktopButton","visible":false,"position":"stackedBR"}
        ]}
      '';
    };
  };
}
