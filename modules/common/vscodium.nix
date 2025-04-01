# Doesn't work
{ pkgs, inputs, ... }:
let
  system = pkgs.system;
  ext = inputs.nix-vscode-extensions.extensions.${system};
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with ext.vscode-marketplace; [ kde.breeze ];
    };
  };
}