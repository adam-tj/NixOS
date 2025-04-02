{ pkgs, ... }:

{
  programs.fish.enable = true;
  users.users.adam.shell = pkgs.fish;
}
