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
  slippi-launcher.enable = true; # Ensure the service/program is enabled
  slippi-launcher.isoPath = "/home/adam/Games/ROMS/animelee.iso";
  slippi-launcher.rootSlpPath = "/home/adam/Games/Slippi";
  slippi-launcher.launchMeleeOnPlay = false;
  slippi-launcher.useMonthlySubfolders = true;
  slippi-launcher.enableJukebox = true;
  slippi-launcher.useNetplayBeta = false;

  # Lutris + ProtonGE
  programs.lutris = {
    enable = true;
    package = pkgs-unstable.lutris;
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
    gamemode
    #hunspell
    jellyfin-mpv-shim
    legcord
    mangohud mediainfo mesa-demos mesen
    piper plex-mpv-shim
    qbittorrent
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
    smplayer steam-art-manager svp
    vapoursynth vapoursynth-mvtools vlc vorbis-tools vscodium
    zed-editor-fhs
    winboat
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
