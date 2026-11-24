{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  # CPU-only inference is too slow for interactive dictation on frieda.
  voxtypePackage = pkgs.voxtype.override { vulkanSupport = true; };
  voxtype = lib.getExe voxtypePackage;
  whisperModel = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/ggml-small-q5_1.bin";
    hash = "sha256-roXkqTXXpWe9EC/lWvwWu1lb22GOEbL8dZG8CBIEEbs=";
  };
in
{
  home.packages = [ voxtypePackage ];

  xdg.configFile."voxtype/config.toml".source = (pkgs.formats.toml { }).generate "voxtype.toml" {
    state_file = "auto";
    # Let GNOME own the shortcut instead of giving Voxtype raw keyboard access.
    hotkey.enabled = false;

    # Voxtype 0.7.2 requires these fields even with the stock capture settings.
    audio = {
      device = "default";
      sample_rate = 16000;
      max_duration_secs = 60;
    };

    whisper = {
      mode = "local";
      model = "${whisperModel}";
      # A language allowlist runs a separate full-context detection pass.
      language = "auto";
      context_window_optimization = true;
    };

    output = {
      mode = "paste";
      # Ghostty uses Ctrl+Shift+V. Clipboard paste preserves umlauts.
      paste_keys = "ctrl+shift+v";
      # Keep dictation in the editor for review even if upstream defaults change.
      auto_submit = false;
      notification = {
        on_recording_start = true;
        on_recording_stop = true;
        on_transcription = false;
      };
    };
    text.smart_auto_submit = false;
  };

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/voxtype/"
    ];
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/voxtype" = {
      name = "Toggle dictation";
      command = "${voxtype} record toggle";
      binding = "<Super><Shift>v";
    };
  };

  systemd.user.services.voxtype = {
    Unit = {
      Description = "Local voice dictation";
      After = [
        "graphical-session.target"
        "pipewire.service"
      ];
      PartOf = [ "graphical-session.target" ];
    };

    # Inherit the session PATH so wl-copy can find cat and other helpers.
    Service = {
      ExecStart = "${voxtype} daemon";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = [
        "YDOTOOL_SOCKET=${osConfig.environment.variables.YDOTOOL_SOCKET}"
        # Info-level logs contain transcripts.
        "RUST_LOG=warn"
      ];
      # Allow desktop and audio sockets but no connections to a remote engine.
      RestrictAddressFamilies = [ "AF_UNIX" ];
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
