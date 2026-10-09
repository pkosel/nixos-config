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

    # nixpkgs' pi-coding-agent lags upstream by a major version.
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

    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
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
        # Unused arguments and bindings. hardware.nix is generated; the nvim
        # module's unused pomo-nvim waits for the Neovim cleanup (see
        # home/editors/nvim/TODO.md), after which that exclusion goes.
        deadnix = pkgs.runCommand "deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          cd ${./.}
          deadnix --fail . --exclude hosts/frieda/hardware.nix home/editors/nvim/default.nix
          touch $out
        '';

        # Anti-patterns. The disabled rule and ignored paths are in statix.toml.
        statix = pkgs.runCommand "statix" { nativeBuildInputs = [ pkgs.statix ]; } ''
          cd ${./.}
          statix check .
          touch $out
        '';
      };

      nixosConfigurations.frieda = nixpkgs.lib.nixosSystem {
        inherit system;
        # NixOS modules reach flake inputs through this (the nixpkgs overlays,
        # the flake registry pin).
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/frieda/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              # Without this every activation installs home-manager-path into
              # ~/.local/state/nix/profiles as a new generation, which nix.gc
              # (running as root) never prunes. With it the packages ride along
              # in the system closure, so the system generations are the only
              # history there is.
              useUserPackages = true;
              users.philipp = import ./users/philipp.nix;
              # Home Manager modules get the inputs too; firefox uses
              # firefox-addons and betterfox.
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
