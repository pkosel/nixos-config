{ inputs, ... }:

{
  imports = [ inputs.brave.nixosModules.default ];

  programs.brave = {
    enable = true;
    policy.PasswordManagerEnabled = false;
  };

  # Origin shares standard Brave's policy directory.
  environment.etc."brave/policies/recommended/default.json".text = builtins.toJSON {
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Brave Search";
    DefaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
    # Chromium's startup action 1 restores the previous session.
    RestoreOnStartup = 1;
  };
}
