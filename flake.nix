{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nixfmt = {
      url = "github:serokell/nixfmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      supportedSystem = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystem;
    in rec {
      packages = forAllSystems
        (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });

      overlays = import ./overlays;

      nixosConfigurations = {
        # Desktop
        bridget = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/configuration.nix ];
        };
      };

      homeConfigurations = {
        # Desktop
        philipp = home-manager.lib.homeManagerConfiguration {
          # https://github.com/nix-community/home-manager/issues/2942
          #pkgs = nixpkgs.legacyPackages."x86_64-linux";
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [ inputs.nur.overlay outputs.overlays.additions ];
          };
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/home.nix ];
        };
      };

      formatter = forAllSystems (system:
        #nixpkgs.legacyPackages.${system}.nixfmt
        inputs.nixfmt.packages.${system}.nixfmt);
    };
}
