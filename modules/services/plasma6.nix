{ pkgs, pkgsUnstable, pkgsPlasma6, ...}:

# {
#   services.desktopManager.plasma6.enable = true;
#   imports = [ ../common/plasma-workspace-overlay.nix ];
#   environment.systemPackages =
#     with pkgs.kdePackages;
#     [
#       isoimagewriter
#       filelight
#       kaccounts-integration
#       kaccounts-providers
#       kate
#       kclock
#       kolourpaint
#       partitionmanager
#       oxygen
#       oxygen-icons
#       oxygen-sounds
#     ];
# }

{
  imports = [ ../common/plasma-workspace-overlay.nix ];
  services.desktopManager.plasma6 = {enable = true;};
  environment.systemPackages =
    with pkgsPlasma6.kdePackages;
    [
      isoimagewriter
      filelight
      kaccounts-integration
      kaccounts-providers
      kate
      kclock
      kolourpaint
      partitionmanager
      oxygen
      oxygen-icons
      oxygen-sounds
    ];
}