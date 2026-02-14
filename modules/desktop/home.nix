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
    defaultWinePackage = pkgs-unstable.proton-ge-bin;
    protonPackages = [
      pkgs-unstable.proton-ge-bin
    ];
  };

  home.stateVersion = "24.11"; # Do not change this line.

  home.packages = with pkgs-unstable; [
  ];

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
