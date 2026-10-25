{ ... }:

{
  services.printing = {
    enable = true;
    browsed.enable = false;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL_L2350DW";
        description = "Brother HL-L2350DW";
        location = "Home";
        deviceUri = "ipp://192.168.2.30:631/ipp/print";
        # IPP Everywhere queries the printer for capabilities at build time.
        # The printer must be awake during nixos-rebuild.
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "Brother_HL_L2350DW";
  };
}
