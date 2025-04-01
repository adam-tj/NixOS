{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    appimage-run
    bottles
    discord
    flameshot
    gearlever gimp google-chrome
    irssi isoimagewriter
    jetbrains-toolbox jflap
    kdePackages.filelight kdePackages.kate kdePackages.kolourpaint kdePackages.konversation
#     kdePackages.kalk
#     gnome-calculator
#     kdePackages.krdc
#     kodi
    libreoffice-qt6-fresh # lutris
    mangohud mediainfo # mesa-demos mesen
    (mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; })
    nixd nixfmt
#     networkmanagerapplet
    piper plex-desktop plex-mpv-shim protonplus protontricks
#     protonup-qt
    qalculate-qt quasselClient qbittorrent
    remmina
#     sameboy
#     slippi-netplay
    smplayer svp
    tor-browser
    vlc vscodium
    wine
    zapzap zoom-us




    ];
  };
}
