{
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 90d";
  nix.gc.dates = "daily";
}