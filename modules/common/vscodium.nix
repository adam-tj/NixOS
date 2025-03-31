{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions.vscode-marketplace = [ "kde.breeze" ];
    };
}
