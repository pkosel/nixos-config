{ pkgs, ... }:

{
  # Chromium-based browsers on Linux only read extension policies from /etc,
  # so extensions cannot be installed declaratively per-user the way Firefox
  # does via programs.firefox.extensions.packages. Install Proton Pass manually
  # once from the Chrome Web Store:
  # https://chromewebstore.google.com/detail/ghmbeldphafepmbegfdlkpapadhbakde
  home.packages = [ pkgs.brave-origin ];
}
