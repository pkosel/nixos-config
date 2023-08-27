{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

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
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
    in
    {
      overlays = import ./overlays;
      packages = forEachPkgs (pkgs: import ./pkgs { inherit pkgs; });

      nixosConfigurations = {
        # Desktop
        bridget = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/configuration-desktop.nix ];
        };

        # Laptop
        frida = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/configuration-laptop.nix ];
        };
      };

      homeConfigurations = {
        # Desktop
        philipp = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/home.nix ];
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
        };
      };

      formatter = forEachPkgs (pkgs: pkgs.nixpkgs-fmt);
    };
}
