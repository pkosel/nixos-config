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

    # Both overlays below build with this flake's nixpkgs (final.callPackage),
    # so the nixpkgs trees these inputs lock themselves are never used for what
    # gets installed. Following keeps them out of flake.lock. Neither has a
    # binary cache that matches that build, so every update builds locally.
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs' pi-coding-agent lags upstream by a major version. Drop this input
    # and its overlay in system/nixpkgs.nix once nixpkgs catches up with stable.
    pi = {
      url = "github:earendil-works/pi/stable";
      inputs.nixpkgs.follows = "nixpkgs";
      # nixpkgs-darwin-x64 is left alone: it only serves pi's own x86_64-darwin
      # package, so it is never evaluated here.
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
        # hardware.nix is generated. The nvim module's unused pomo-nvim stays
        # excluded until the Neovim cleanup (home/editors/nvim/TODO.md) removes it.
        deadnix = pkgs.runCommand "deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          cd ${./.}
          deadnix --fail . --exclude hosts/frieda/hardware.nix home/editors/nvim/default.nix
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
          ./hosts/frieda/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              # Without this, every activation installs home-manager-path into
              # ~/.local/state/nix/profiles as a new generation, which nix.gc
              # (running as root) never prunes. With it, the packages ride along
              # in the system closure, so system generations are the only history.
              useUserPackages = true;
              users.philipp = import ./users/philipp.nix;
              # Home Manager modules get the inputs too; firefox uses
              # firefox-addons.
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
