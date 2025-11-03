{ pkgs, pkgsWithSVP, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    packages = with pkgs; [
      appimage-run
      emulationstation-de
      gamemode
      irssi isoimagewriter
      jdk jflap   jellyfin-mpv-shim jetbrains-toolbox
      lutris
      mangohud mediainfo mesa-demos mesen
      nix-ld
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
      libretro.mesen
      smplayer #svp
      vlc vscodium
      wine

#jellyfin-media-player

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
    ])
    ;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    gdk-pixbuf
    xorg.libSM
    xorg.libICE
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    freetype
    SDL2
    gtk3
    pango
    harfbuzz
    atk
    cairo
    glib
  ];

  

  # Jellyfin vapoursynth
  # nixpkgs.overlays = [
  #   (self: super: {
  #     mpv-unwrapped =
  #       super.mpv-unwrapped.override { vapoursynthSupport = true; };
  #     youtubeSupport = true;
  #   })
  # ];
    

}
