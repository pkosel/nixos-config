{ ... }:

{
  programs.zoxide = {
    enable = true;
    # Replace cd with z so every directory change feeds the database. The
    # original cd stays available as __zoxide_cd or \cd.
    options = [ "--cmd cd" ];
  };
}
