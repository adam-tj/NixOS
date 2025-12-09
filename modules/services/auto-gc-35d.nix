{
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 35d";
  nix.gc.dates = "daily";
}
