{ pkgs, pkgsUnstable, pkgsWithSVP, pkgsWithBgrt, pkgsWithMpvVs, ... }:

{
  environment.systemPackages =
    with pkgsUnstable;
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
      jdk jellyfin-mpv-shim jetbrains-toolbox #jellyfin-media-player
      killall
      lsof lutris
      mangohud mediainfo mesa-demos mesen mlocate #mpv-vapoursynth
      #(mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; })
      nixd nixfmt-rfc-style neovim-unwrapped neovim-qt-unwrapped
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
      smplayer #svp
      usbutils
      vapoursynth vapoursynth-mvtools vlc vorbis-tools vscodium vulkan-tools
      wine wget
      zed-editor-fhs
    ]
    ++ (with pkgsUnstable; [
      #proton-ge-bin
      winboat
     ])
    ++ (with pkgsWithSVP; [
      svp-with-mpv
     ])
    ++ (with pkgsWithMpvVs; [
      mpv-vs
    ])
    ++ (with kdePackages; [
      filelight
      kaccounts-integration
      kaccounts-providers
      kate
      kclock
      kolourpaint
      isoimagewriter
      partitionmanager
     ])
    ++ (with hunspellDicts; [
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
    ++ (with nerd-fonts; [
      _0xproto
      _3270
      adwaita-mono
      agave
      anonymice
      arimo
      atkynson-mono
      aurulent-sans-mono
      bigblue-terminal
      bitstream-vera-sans-mono
      blex-mono
      caskaydia-cove
      caskaydia-mono
      code-new-roman
      comic-shanns-mono
      commit-mono
      cousine
      d2coding
      daddy-time-mono
      dejavu-sans-mono
      departure-mono
      droid-sans-mono
      envy-code-r
      fantasque-sans-mono
      fira-code
      fira-mono
      geist-mono
      go-mono
      gohufont
      hack
      hasklug
      heavy-data
      hurmit
      im-writing
      inconsolata
      inconsolata-go
      inconsolata-lgc
      intone-mono
      iosevka
      iosevka-term
      iosevka-term-slab
      jetbrains-mono
      lekton
      liberation
      lilex
      martian-mono
      meslo-lg
      monaspace
      monofur
      monoid
      mononoki
      noto
      open-dyslexic
      overpass
      profont
      proggy-clean-tt
      recursive-mono
      roboto-mono
      sauce-code-pro
      shure-tech-mono
      space-mono
      symbols-only
      terminess-ttf
      tinos
      ubuntu
      ubuntu-mono
      ubuntu-sans
      victor-mono
      zed-mono
     ]);
}
