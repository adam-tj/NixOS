{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    packages = with pkgs; [
      appimage-run
      bottles
      discord
      gearlever gimp google-chrome
      irssi isoimagewriter
      jdk jellyfin-media-player jellyfin-mpv-shim jetbrains-toolbox jflap
      kdePackages.filelight kdePackages.kate kdePackages.kolourpaint kdePackages.konversation
      libreoffice-fresh
      mangohud mediainfo mesa-demos
      (mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; })
      plex-desktop plex-mpv-shim protonplus protontricks
      qalculate-qt quasselClient qbittorrent
      remmina
      skypeforlinux smplayer svp
      vlc vscodium
      wine
      zapzap zoom-us
    ];
  };
}
