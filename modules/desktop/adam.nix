{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      lutris
      obs-studio
      r2modman
  #svp-with-mpv
  #mpvWithSVP
      #jellyfin-media-player-svp

    ];
  };
}
