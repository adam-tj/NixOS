{ pkgs, pkgsWithSVP, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    packages = with pkgs; [
      appimage-run
      emulationstation-de
      gamemode
      hunspell
      irssi isoimagewriter
      jdk   jellyfin-mpv-shim jetbrains-toolbox
      libreoffice-qt lutris
      mangohud mediainfo mesa-demos mesen
      #(mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; })
      #( mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; extraMakeWrapperArgs = [ "--prefix" "LD_LIBRARY_PATH" ":" "/run/opengl-driver/lib:${lib.makeLibraryPath [ ocl-icd ]}" ]; } )
      piper plex-mpv-shim
      qbittorrent
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
      smplayer #svp
      vlc vorbis-tools vscodium
      wine



      #jellyfin-media-player.override { 
   #   mpv = svp.passthru.mpv; 
   #}

      #( jellyfin-mpv-shim.override { mpv = pkgs.mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; }; })
      #( jellyfin-mpv-shim.override { mpv = pkgs.svp.mpv; } )
      #( jellyfin-mpv-shim.override { mpv = mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; }; } )
    ] ++ (with pkgsWithSVP; [
      svp-with-mpv
      #jellyfin-with-svp.jellyfin-media-player
    ]) ++ (with kdePackages; [
      filelight
      kaccounts-integration
      kaccounts-providers
      kate
      kclock
      kolourpaint
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
  };  

  # Jellyfin vapoursynth
  # nixpkgs.overlays = [
  #   (self: super: {
  #     mpv-unwrapped =
  #       super.mpv-unwrapped.override { vapoursynthSupport = true; };
  #     youtubeSupport = true;
  #   })
  # ];
    

}
