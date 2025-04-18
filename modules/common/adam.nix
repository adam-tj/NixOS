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
      mangohud mediainfo mediainfo-gui mesa-demos
      #(mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; })
      #( mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; extraMakeWrapperArgs = [ "--prefix" "LD_LIBRARY_PATH" ":" "/run/opengl-driver/lib:${lib.makeLibraryPath [ ocl-icd ]}" ]; } )
      plex-desktop plex-mpv-shim protonplus protontricks
      qalculate-qt quasselClient qbittorrent
      remmina
      skypeforlinux smplayer #svp
      thunderbird tor-browser
      vlc vscodium
      wine
      zoom-us

      #( jellyfin-mpv-shim.override { mpv = pkgs.mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; }; })
      #( jellyfin-mpv-shim.override { mpv = pkgs.svp.mpv; } )
      #( jellyfin-mpv-shim.override { mpv = mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; }; } )
    ] ++ (with kdePackages; [
      dolphin-plugins
      filelight
      kaccounts-integration
      kaccounts-providers
      kio
      kio-extras
      kio-fuse
      kio-gdrive
      kate
      kolourpaint
    ]);
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
