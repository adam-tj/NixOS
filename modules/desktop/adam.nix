{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      appimage-run
      bottles
      discord
      element-desktop
      /* flameshot */
      gearlever gimp google-chrome
      irssi isoimagewriter
      /* glxinfo */
      jdk jellyfin-media-player jellyfin-mpv-shim jetbrains-toolbox jflap
      kdePackages.filelight kdePackages.kate kdePackages.kolourpaint kdePackages.konversation
      libreoffice-fresh /* lutris */
      mangohud mediainfo mesa-demos /* mesen */
      /* nix-janitor */
      (mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; })
      obs-studio
      piper plex-desktop plex-mpv-shim protonplus protontricks
      qalculate-qt quasselClient qbittorrent /* quadrapassel */
      r2modman remmina
      /* sameboy */ skypeforlinux /* slippi-netplay */ smplayer svp
      vlc
      wine
      zapzap zoom-us
    ];
  };
}
