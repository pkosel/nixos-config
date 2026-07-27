{
  description = "Philipp's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code.url = "github:sadjow/claude-code-nix";

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
    inputs@{
      nixpkgs,
      home-manager,
      claude-code,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      nixosConfigurations.frieda = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            nixpkgs.overlays = [
              claude-code.overlays.default
              (final: prev: {
                mdcat = final.callPackage ./pkgs/mdcat.nix { };

                # Fix crash on file dialogs (e.g. Import): anki's Qt6 GTK3 theme
                # integration needs a schema shipped by gtk3, which isn't part of
                # this GNOME session's (gtk4-based) XDG_DATA_DIRS.
                anki = prev.symlinkJoin {
                  name = "anki-${prev.anki.version}";
                  paths = [ prev.anki ];
                  nativeBuildInputs = [ prev.makeWrapper ];
                  postBuild = ''
                    wrapProgram $out/bin/anki \
                      --prefix XDG_DATA_DIRS : ${prev.gtk3}/share/gsettings-schemas/${prev.gtk3.name}
                  '';
                };
              })
            ];
          }

          ./hosts/frieda/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.philipp = import ./users/philipp.nix;
            # Home Manager modules reach flake inputs through this; firefox uses
            # firefox-addons and betterfox.
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
}
