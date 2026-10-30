{ ... }:

{
  programs.zoxide = {
    enable = true;
    # Use builtin cd to bypass zoxide queries; the PWD hook can still record
    # directory changes.
    options = [ "--cmd cd" ];
  };
}
