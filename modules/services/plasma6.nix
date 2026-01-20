{ pkgs, pkgsUnstable, ...}:

{
  services.desktopManager.plasma6.enable = true;
  imports = [ ../common/plasma-workspace-overlay.nix ];
  environment.systemPackages =
    with pkgs.kdePackages;
    [
      isoimagewriter
      filelight
      kaccounts-integration
      kaccounts-providers
      kate
      kclock
      kolourpaint
      partitionmanager
    ];
}
