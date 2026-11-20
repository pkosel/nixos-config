{ ... }:

{
  # Origin shares Brave's policy directory. Set policies there directly so
  # Chrome and Chromium are unaffected.
  environment.etc = {
    "brave/policies/managed/default.json".text = builtins.toJSON {
      PasswordManagerEnabled = false;
    };

    "brave/policies/recommended/default.json".text = builtins.toJSON {
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Brave Search";
      DefaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
      # Chromium's startup action 1 restores the previous session.
      RestoreOnStartup = 1;
    };
  };
}
