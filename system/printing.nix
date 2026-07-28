{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    # cups-browsed creates a flaky, mDNS-dependent "implicitclass" queue that
    # gets disabled whenever the printer's broadcast has a hiccup ("Printer
    # disappeared or cups-browsed shutdown"). Use a static queue instead.
    browsed.enable = false;

    # Only brlaser: it has the PPD named below and the rastertobrlaser filter.
    # cups-filters comes with the module, and BrGenML1 is a competing driver for
    # this printer that nothing selects.
    drivers = [ pkgs.brlaser ];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL_L2350DW";
        description = "Brother HL-L2350DW";
        location = "Home";
        deviceUri = "ipp://BRW60E9AAE1E61D.local:631/ipp/print";
        # Use the brlaser PPD rather than model = "everywhere": IPP Everywhere
        # makes lpadmin query the printer to build the PPD, so every rebuild
        # fails while the printer is asleep. An explicit PPD is resolved offline.
        model = "drv:///brlaser.drv/brl2350d.ppd";
      }
    ];
    ensureDefaultPrinter = "Brother_HL_L2350DW";
  };

  # Resolves the printer's .local name; openFirewall opens mDNS (udp 5353), the
  # only hole printing needs — cupsd binds loopback, and sending a job is
  # outbound.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
