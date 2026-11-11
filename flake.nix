{
  description = "Philipp's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs' pi-coding-agent trails stable; remove this input and its
    # overlay in modules/system/nixpkgs.nix once it catches up.
    pi = {
      url = "github:earendil-works/pi/stable";
      # The overlay uses the root nixpkgs; follow both inputs to avoid unused trees.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-darwin-x64.follows = "nixpkgs";
    };

    brave = {
      url = "git+https://codeberg.org/buckley310/brave-browser-nix?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.treefmt.withConfig {
        settings = {
          tree-root-file = "flake.nix";
          excludes = [
            "hosts/*/hardware-configuration.nix"
            "flake.lock"
          ];

          formatter = {
            nixfmt = {
              command = "${pkgs.nixfmt}/bin/nixfmt";
              includes = [ "*.nix" ];
            };

            stylua = {
              command = "${pkgs.stylua}/bin/stylua";
              includes = [ "*.lua" ];
            };

            biome = {
              command = "${pkgs.biome}/bin/biome";
              options = [
                "format"
                "--write"
              ];
              includes = [ "*.ts" ];
            };
          };
        };
      };

      packages.${system}.disko = inputs.disko.packages.${system}.disko;

      checks.${system} = {
        # Generated hardware configuration is not linted.
        deadnix = pkgs.runCommand "deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          cd ${./.}
          deadnix --fail . --exclude hosts/frieda/hardware-configuration.nix
          touch $out
        '';

        statix = pkgs.runCommand "statix" { nativeBuildInputs = [ pkgs.statix ]; } ''
          cd ${./.}
          statix check .
          touch $out
        '';
      };

      nixosConfigurations.frieda = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/frieda/default.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.philipp = import ./users/philipp/default.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
