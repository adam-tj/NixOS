{ pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    jellyfin-ffmpeg
    jellyfin-web
  ];
}
