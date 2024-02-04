{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system} = import ./pkgs { inherit pkgs; };

      overlays = {
        additions = (final: _prev: import ./pkgs { pkgs = final; });
      };

      nixosConfigurations = {
        # Desktop
        bridget = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs self; };

          modules = [
            ./hosts/configuration-desktop.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.philipp = import ./home/home.nix;
              home-manager.extraSpecialArgs = inputs;
            }
          ];
        };

        # Laptop
        frieda = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs self; };

          modules = [
            ./hosts/configuration-laptop.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.philipp = import ./home/home.nix;
              home-manager.extraSpecialArgs = inputs;
            }
          ];
        };
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
