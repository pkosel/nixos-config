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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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
    inputs@{
      nixpkgs,
      home-manager,
      treefmt-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      packages.${system}.disko = inputs.disko.packages.${system}.disko;

      formatter.${system} = treefmt.config.build.wrapper;
      checks.${system}.formatting = treefmt.config.build.check inputs.self;

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
