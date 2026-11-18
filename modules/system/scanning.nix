{ pkgs, ... }:

{
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    # On the ADS-1800W, the built-in backend creates a duplicate entry without duplex.
    disabledDefaultBackends = [ "escl" ];
  };
}
