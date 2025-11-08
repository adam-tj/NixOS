{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      nix-ld
      obs-studio
      r2modman
      tes3cmd
  #svp-with-mpv
  #mpvWithSVP
      #jellyfin-media-player-svp

    ];
  };
}
