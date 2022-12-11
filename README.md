# nixos-config

## Install

Clone the configuration into `/etc/nixos`.

On a new machine run:

```sh
scripts/setup-partitions
```

Then move the resulting `/mnt/etc/nixos/hardware-configuration.nix` to
`./hosts/<host>/hardware-configuration.nix`. Copy the configuration from
`/etc/nixos` to `/mnt/etc/nixos`.

To install run the following command where `<host>` matches one of the hosts
defined in `./hosts/default.nix`, i.e. `bridget`:

```sh
nixos-install --flake .#<host>
```

After the installation has finished, set a password for the user:

```sh
passwd <user>
```

## Update

Update all flake inputs:

```sh
nix flake update
```

## Rebuild

Rebuild the system:

```sh
nixos-rebuild switch --flake .#<host>
```

## References

- [https://github.com/MatthiasBenaets/nixos-config](https://github.com/MatthiasBenaets/nixos-config)
- [https://gitlab.com/felschr/nixos-config](https://gitlab.com/felschr/nixos-config)

