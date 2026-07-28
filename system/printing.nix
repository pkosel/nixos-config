{ pkgs, ... }:

{
  services.printing = {
    enable = true;
    # cups-browsed creates a flaky, mDNS-dependent "implicitclass" queue that
    # gets disabled whenever the printer's broadcast has a hiccup ("Printer
    # disappeared or cups-browsed shutdown"). Use a static queue instead.
    browsed.enable = false;

    # Only brlaser: it supplies the PPD the queue below names, and its
    # rastertobrlaser filter. cups-filters is already in the module's own
    # package set, and brother's generic BrGenML1 driver is a competing driver
    # for this same printer that nothing here selects.
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

  # Resolves the printer's .local name; openFirewall opens mDNS (udp 5353).
  #
  # That is the only hole printing needs. cupsd binds loopback only, so an
  # inbound rule for tcp 631 would guard a port nothing can reach, and sending
  # a job is an outbound connection the firewall already allows.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
