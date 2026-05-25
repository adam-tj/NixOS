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
      "mbedtls-2.28.10"
      "mbedtls_2-2.28.10"
      "qtwebengine-5.15.19"
      "googleearth-pro-7.3.6.10201"
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
    bottles
    deluge devilutionx discord distroshelf
    element-desktop
    gamemode gearlever gemini-cli gimp googleearth-pro goofcord
    heroic #hunspell
    itch
    joplin-desktop jellyfin-mpv-shim
    legcord
    mangohud mediainfo mediainfo-gui mesa-demos mesen
    obs-studio
    piper plex-mpv-shim protonplus protontricks
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
    remmina rssguard
    smplayer steam-art-manager svp
    tor-browser /* trgui-ng bugged at the moment */
    vaults vapoursynth vapoursynth-mvtools vlc vorbis-tools vscodium
    winboat
    zapzap zed-editor-fhs zoom-us
    ]
    ++ (with jetbrains; [
        idea
        pycharm
    ])
    ++ (with pkgsWithMpvVs; [
      jellyfin-desktop
      mpv
    ])
    #++ (with hunspellDicts; [
    #  de_DE
    #  en-gb-ise en-gb-ize en-gb-large en-us en-us-large en_GB-ise en_GB-ize en_GB-large en_US en_US-large
    #  hu-hu hu_HU
    #  it-it it_IT
    #  sv-se sv_SE
    #])
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
    };

  home.sessionVariables = {
    EDITOR = "vim";
    };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };


  programs.home-manager.enable = true;

}
