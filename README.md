# My NixOS configurations

## Bootstrapping

For bootstrapping a flake-enabled nix environment on a fresh install run:

```
nix-shell
```

Use `nixos-rebuild --flake .` to build system configurations.  
Use `home-manager --flake .` to build user configurations.

## References

- [https://m7.rs/git/nix-config/](https://m7.rs/git/nix-config/)
- [https://gitlab.com/felschr/nixos-config](https://gitlab.com/felschr/nixos-config)

