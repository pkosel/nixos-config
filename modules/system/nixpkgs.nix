{ inputs, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.pi.overlays.default
      (import ../../overlays)
    ];
  };
}
