{
  config,
  inputs,
  pkgs,
  pkgs-unstable,
  pkgsWithMpvVs,
  ...
}:

{
  home.username = "adam";
  home.homeDirectory = "/home/adam";

  # Slippi
  imports = [
    inputs.slippi.homeManagerModules.default
  ];

  nixpkgs.config = {
    permittedInsecurePackages = [
      #"freeimage-3.18.0-unstable-2024-04-18"
      #"mbedtls-2.28.10"
      #"mbedtls_2-2.28.10"
      #"qtwebengine-5.15.19"
      #"googleearth-pro-7.3.7.1155"
    ];
  };

  slippi-launcher = {
      enable = true;
      isoPath = "/home/adam/Games/ROMS/animelee.iso";
      rootSlpPath = "/home/adam/Games/Slippi";
      launchMeleeOnPlay = false;
      useMonthlySubfolders = true;
      enableJukebox = true;
      useNetplayBeta = false;
    };

  # Lutris + ProtonGE
  programs.lutris = {
    enable = true;
    #package = customLutris;
    extraPackages = with pkgs-unstable; [
      gamemode
    ];
    defaultWinePackage = pkgs-unstable.proton-ge-bin;
    protonPackages = [
      pkgs-unstable.proton-ge-bin
    ];
  };

  home.stateVersion = "24.11"; # Do not change this line.

  home.packages = with pkgs-unstable; [
    _7kaa
    bitwarden-desktop rbw
    collabora-desktop
    #bottles
    deluge devilutionx discord distroshelf
    element-desktop
    firefoxpwa
    gamemode gearlever gemini-cli gimp /* google-chrome */ googleearth-pro goofcord
    heroic #hunspell
    itch
    joplin-desktop #jellyfin-mpv-shim
    karere
    libreoffice-qt-fresh legcord
    mangohud mediainfo mediainfo-gui mesa-demos mesen
    nextcloud-client
    obs-studio
    piper /* plex-mpv-shim */ protonplus protontricks
    qalculate-qt qbittorrent quasselClient
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
    r2modman remmina rssguard
    smplayer steam-art-manager svp
    tor-browser trgui-ng
    vaults vapoursynth vapoursynth-mvtools vlc vorbis-tools vscodium
    widevine-cdm winboat
    zapzap zoom-us
    ]
    ++ [ inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default 
      inputs.waterfox.packages.${pkgs.stdenv.hostPlatform.system}.waterfox-bin ]
    ++ (with jetbrains; [
        clion
        idea
        jdk
        pycharm
        rust-rover
    ])
    ++ (with pkgs; [
        #plex-mpv-shim jellyfin-mpv-shim
    ])
    ++ (with pkgsWithMpvVs; [
      jellyfin-desktop
      mpv
    ])
    ++ (with hunspellDicts; [
     de_DE en-gb-large en-us-large hu-hu it-it sv-se
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

  home.file = {
    # Enable Widevine
    ".config/net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = 
      builtins.toJSON {
        #Path = "${pkgs.google-chrome}/share/google/chrome/WidevineCdm";
        Path = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm";
    };
    ".waterfox/native-messaging-hosts" = {
      source = "${pkgs.firefoxpwa}/lib/mozilla/native-messaging-hosts";
      recursive = true;
    };
  };


  home.sessionVariables = {
    EDITOR = "vim";
    };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };


  programs.home-manager.enable = true;

}
