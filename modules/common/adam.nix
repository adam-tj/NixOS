{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    packages = with pkgs; [
      appimage-run
      bottles
      discord
      gamemode gearlever gimp google-chrome
      irssi isoimagewriter
      jdk /* jellyfin-media-player */ /* jellyfin-mpv-shim */ jetbrains-toolbox jflap
      kdePackages.filelight kdePackages.kate kdePackages.kolourpaint kdePackages.konversation
      libreoffice-fresh
      mangohud mediainfo mediainfo-gui mesa-demos
      #(mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; })
      #( mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; extraMakeWrapperArgs = [ "--prefix" "LD_LIBRARY_PATH" ":" "/run/opengl-driver/lib:${lib.makeLibraryPath [ ocl-icd ]}" ]; } )
      plex-desktop plex-mpv-shim protonplus protontricks
      qalculate-qt quasselClient qbittorrent
      remmina
      skypeforlinux smplayer #svp
      tor-browser
      vlc vscodium
      wine
      zapzap zoom-us

      #( jellyfin-mpv-shim.override { mpv = pkgs.mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; }; })
      #( jellyfin-mpv-shim.override { mpv = pkgs.svp.mpv; } )
      #( jellyfin-mpv-shim.override { mpv = mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; }; } )
    ];
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
