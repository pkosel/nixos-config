{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2311.tar.gz";

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.2311.tar.gz";
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
