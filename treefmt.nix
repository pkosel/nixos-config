{
  projectRootFile = "flake.nix";

  settings.excludes = [ "hosts/*/hardware-configuration.nix" ];

  programs = {
    # Apply lint fixes before nixfmt so one pass leaves Nix files formatted.
    deadnix = {
      enable = true;
      priority = 1;
    };
    statix = {
      enable = true;
      priority = 2;
      # Share lint rules with editor invocations of statix.
      disabled-lints = (builtins.fromTOML (builtins.readFile ./statix.toml)).disabled;
    };
    nixfmt = {
      enable = true;
      priority = 3;
    };

    stylua.enable = true;
    biome = {
      enable = true;
      formatCommand = "format";
      includes = [ "*.ts" ];
    };

    shellcheck.enable = true;
  };
}
