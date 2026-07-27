{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    browsing = true;
    # cups-browsed creates a flaky, mDNS-dependent "implicitclass" queue that
    # gets disabled whenever the printer's broadcast has a hiccup ("Printer
    # disappeared or cups-browsed shutdown"). Use a static queue instead.
    browsed.enable = false;

    drivers = with pkgs; [
      cups-filters
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
    ];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL_L2350DW";
        description = "Brother HL-L2350DW";
        location = "Home";
        deviceUri = "ipp://BRW60E9AAE1E61D.local:631/ipp/print";
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "Brother_HL_L2350DW";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  users.users.philipp.extraGroups = [
    "lp"
    "printer"
  ];

  networking.firewall.allowedTCPPorts = [ 631 ];
  networking.firewall.allowedUDPPorts = [
    5353
    631
  ];
}
