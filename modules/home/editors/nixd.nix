{ inputs, pkgs }:

let
  configurationExpression = ''(builtins.getFlake "path:${inputs.self}?narHash=${inputs.self.narHash}").nixosConfigurations.frieda'';
in
{
  nixpkgs.expr = "${configurationExpression}.pkgs";
  formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
  options = {
    nixos.expr = "${configurationExpression}.options";
    home-manager.expr = "${configurationExpression}.options.home-manager.users.type.getSubOptions []";
  };
}
