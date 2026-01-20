{ pkgs, pkgsUnstable, pkgsWithSVP, pkgsWithBgrt, pkgsWithMpvVs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      appimage-run
      btop
      cryfs
      distrobox dysk
      encfs
      fastfetch
      gamemode gcc gh git gnugrep gnumake gocryptfs
      htop hunspell
      irssi
      jdk jellyfin-mpv-shim
      killall
      lsof lutris
      mangohud mediainfo mesa-demos mesen mlocate
      nixd nixfmt neovim-unwrapped neovim-qt-unwrapped nh nom nvd nix-tree
      ocl-icd opencl-headers # openrgb-with-all-plugins
      pciutils piper plex-mpv-shim
      qbittorrent
      rar
      (retroarch.withCores (
        cores: with libretro; [
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
        ]
       ))
      smplayer svp
      usbutils
      vapoursynth vapoursynth-mvtools vlc vorbis-tools vscodium vulkan-tools
      wine wget
      zed-editor-fhs
    ]
    ++ (with pkgsUnstable; [
      winboat
     ])
    ++ (with pkgsWithSVP; [
      #svp-with-mpv
     ])
    ++ (with pkgsWithMpvVs; [
      #mpv-vs
      jellyfin-desktop
      mpv
    ])
    ++ (with jetbrains; [
      idea
      pycharm
    ])
    ++ (with hunspellDicts; [
      de_DE
      en-gb-ise en-gb-ize en-gb-large en-us en-us-large en_GB-ise en_GB-ize en_GB-large en_US en_US-large
      hu-hu hu_HU
      it-it it_IT
      sv-se sv_SE
     ])
    ++ (with nerd-fonts; [
      adwaita-mono
      bitstream-vera-sans-mono
      dejavu-sans-mono droid-sans-mono
      hack
      jetbrains-mono
      liberation
      noto
      roboto-mono
      space-mono
      terminess-ttf
      ubuntu-mono ubuntu-sans
      zed-mono
     ]);
}
