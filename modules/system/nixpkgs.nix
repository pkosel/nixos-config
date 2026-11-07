{ inputs, ... }:

{
  imports = [ inputs.brave.nixosModules.default ];

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.pi.overlays.default
      (import ../../overlays)
    ];
  };
}
