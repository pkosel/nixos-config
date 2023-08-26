{ config, pkgs, ... }:
{
  home.sessionVariables.LEDGER_FILE = "/home/philipp/Documents/finance/hledger.journal";

  home.packages = with pkgs; [
    hledger
  ];
}
