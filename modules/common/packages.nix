{ pkgs, pkgsUnstable, pkgsWithSVP, ... }:

{
  environment.systemPackages = with pkgs; [
    appimage-run
    btop
    distrobox
    emulationstation-de
    fastfetch
    gamemode gh git gnugrep
    htop hunspell
    irssi isoimagewriter
    jdk   jellyfin-mpv-shim jetbrains-toolbox
    killall
    libreoffice-qt lsof lutris
    mangohud mediainfo mesa-demos mesen mlocate
    nixd nixfmt-rfc-style
    ocl-icd opencl-headers # openrgb-with-all-plugins
    pciutils piper plex-mpv-shim
    qbittorrent
    rar
    (retroarch.withCores (cores: with libretro; [
      beetle-psx-hw
      bsnes
      citra
      desmume
      dolphin
      mame
      mesen
      mgba
      mupen64plus
      pcsx2
      ppsspp
      sameboy
    ]))
    smplayer
    usbutils
    vim vlc vorbis-tools vscodium vulkan-tools
    wine wget
    #jellyfin jellyfin-web jellyfin-ffmpeg
    ] ++ (with pkgsUnstable; [
      #jellyfin-with-svp.jellyfin-media-player    
    ]) ++ (with pkgsWithSVP; [
      svp-with-mpv
      #jellyfin-with-svp.jellyfin-media-player
    ]) ++ (with kdePackages; [
      filelight
      kaccounts-integration
      kaccounts-providers
      kate
      kclock
      kolourpaint
      partitionmanager
    ]) ++ (with hunspellDicts; [
      de_DE
      en-gb-ise
      en-gb-ize
      en-gb-large
      en-us
      en-us-large
      en_GB-ise
      en_GB-ize
      en_GB-large
      en_US
      en_US-large
      hu-hu
      hu_HU
      it-it
      it_IT
      sv-se
      sv_SE
    ])
;
}
