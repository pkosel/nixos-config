{
  description = "Philipp's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Must track the same release as nixpkgs; a mismatched pair is the usual way
    # home-manager breaks.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Both overlays below build with this flake's nixpkgs, so the trees
    # these inputs lock are never used. Following keeps them out of flake.lock.
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs' pi-coding-agent lags upstream. Drop this input and its
    # overlay in modules/nixos/nixpkgs.nix once nixpkgs catches up with stable.
    pi = {
      url = "github:earendil-works/pi/stable";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-darwin-x64.follows = "nixpkgs";
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
      formatter.${system} = pkgs.nixfmt-tree;

      # Run by `nix flake check`.
      checks.${system} = {
        # hardware-configuration.nix is generated and stays excluded.
        deadnix = pkgs.runCommand "deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          cd ${./.}
          deadnix --fail . --exclude hosts/frieda/hardware-configuration.nix
          touch $out
        '';

        # Disabled rules and ignored paths are set in statix.toml.
        statix = pkgs.runCommand "statix" { nativeBuildInputs = [ pkgs.statix ]; } ''
          cd ${./.}
          statix check .
          touch $out
        '';
      };

      nixosConfigurations.frieda = nixpkgs.lib.nixosSystem {
        inherit system;
        # NixOS modules reach flake inputs through this, for the nixpkgs overlays
        # and the flake registry pin.
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/frieda/default.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              # Manage user packages through the NixOS per-user profile.
              useUserPackages = true;
              users.philipp = import ./home/philipp/default.nix;
              # Home Manager modules get inputs; firefox uses firefox-addons.
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
