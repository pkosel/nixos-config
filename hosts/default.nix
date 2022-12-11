{ lib, inputs, system, home-manager, ... }:

{
  bridget = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.philipp = import ./desktop/home.nix;
      }
    ];
  };
}
