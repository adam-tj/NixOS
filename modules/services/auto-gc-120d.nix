{
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 120d";
  nix.gc.dates = "daily";
}