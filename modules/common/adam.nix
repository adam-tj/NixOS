{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    packages = with pkgs; [
    ];
  };
}
