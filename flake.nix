{
  description = "Philipp's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      # Overlay that adds all custom packages
      customPackagesOverlay = final: prev: {
        # Individual package overlays
        claude-code = final.callPackage ./pkgs/claude-code/package.nix { };
        morewaita-icon-theme = final.callPackage ./pkgs/morewaita-icon-theme.nix { };
        window-resizer = final.callPackage ./pkgs/window-resizer.nix { };
      };

      # Create nixpkgs instance with custom overlays and configuration
      pkgsWithOverlays = import nixpkgs {
        inherit system;
        overlays = [ customPackagesOverlay ];
        config.allowUnfree = true;
      };
    in
    {
      # Expose packages for direct building/running
      packages.${system} = {
        inherit (pkgsWithOverlays) claude-code morewaita-icon-theme window-resizer;
      };

      # Expose overlay for others to use
      overlays.default = customPackagesOverlay;

      # Formatter for nix files
      formatter.${system} = pkgsWithOverlays.nixfmt-tree;

      # NixOS configurations
      nixosConfigurations.frieda = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Apply overlay to system packages
          { nixpkgs.overlays = [ self.overlays.default ]; }

          ./hosts/frieda/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.philipp = import ./home/users/philipp.nix;
          }
        ];
      };

      # Development shell
      devShells.${system}.default = import ./shell.nix { inherit pkgsWithOverlays; };
    };
}
