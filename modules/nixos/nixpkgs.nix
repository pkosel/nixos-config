{ inputs, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.claude-code.overlays.default
      inputs.pi.overlays.default
      (import ../../overlays)
    ];
  };
}
