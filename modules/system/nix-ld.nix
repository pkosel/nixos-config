{ pkgs, ... }:

{
  # uvx downloads dynamically linked CPython for FHS Linux.
  # nix-ld provides the linker and lookup path to run such binaries.
  programs.nix-ld = {
    enable = true;
    libraries = [ pkgs.glibc ];
  };
}
