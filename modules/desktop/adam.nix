{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      element-desktop
      obs-studio
      piper
      r2modman
    ];
  };
}
