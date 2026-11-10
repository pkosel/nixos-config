{ ... }:

{
  services.printing = {
    enable = true;
    # A static queue avoids failures when mDNS discovery loses the printer.
    browsed.enable = false;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL_L2350DW";
        description = "Brother HL-L2350DW";
        location = "Home";
        deviceUri = "ipp://192.168.2.30:631/ipp/print";
        # IPP Everywhere needs the printer reachable when ensure-printers runs,
        # for example during initial activation or boot, not during the build.
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "Brother_HL_L2350DW";
  };
}
