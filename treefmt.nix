{
  projectRootFile = "flake.nix";

  settings.excludes = [ "hosts/*/hardware-configuration.nix" ];

  programs = {
    nixfmt.enable = true;

    stylua.enable = true;
    biome = {
      enable = true;
      formatCommand = "format";
      includes = [ "*.ts" ];
    };
  };
}
