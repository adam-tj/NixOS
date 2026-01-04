{ pkgs, ... }:

let
  # Use 'gnugrep' instead of the default 'grep'
  grep = pkgs.gnugrep;
  lib = pkgs.lib;

  # Declare the Flatpaks you *want* on your system
  sharedPackages = import ../common/flatpak-shared.nix;
  localPackages = [
    # Manually installed runtimes
    "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
    "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
    "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/25.08"
    "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08"
    "org.diasurgical.DevilutionX"
    "org.vinegarhq.Sober" # Roblox
  ];
  desiredFlatpaks = lib.unique (sharedPackages ++ localPackages);

  # Declare desired language packs
  desiredLanguages = "en;sv;hu;de;it";

  flatpakScript = pkgs.writeScript "flatpak-management" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Get currently installed Flatpaks
    installedFlatpaks=$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)

    # Set desired languages
    ${pkgs.flatpak}/bin/flatpak config --set languages "${desiredLanguages}"

    # Remove Flatpaks not in the desired list
    for installed in $installedFlatpaks; do
      if ! echo ${lib.concatStringsSep " " desiredFlatpaks} | ${grep}/bin/grep -qw "$installed"; then
        echo "Removing $installed because it's not in the desiredFlatpaks list."
        ${pkgs.flatpak}/bin/flatpak uninstall -y --noninteractive "$installed"
      fi
    done

    # Install or re-install desired Flatpaks
    for app in ${lib.concatStringsSep " " desiredFlatpaks}; do
      echo "Ensuring $app is installed."
      ${pkgs.flatpak}/bin/flatpak install -y --noninteractive flathub "$app"
    done

    # Remove unused Flatpaks
    ${pkgs.flatpak}/bin/flatpak uninstall --unused -y --noninteractive

    # Update all installed Flatpaks
    ${pkgs.flatpak}/bin/flatpak update -y --noninteractive
  '';
in
{
  systemd.services.flatpak-management = {
    description = "Manage Flatpak installations";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${flatpakScript}";
    };
    wantedBy = [ "multi-user.target" ];
  };

    systemd.timers.flatpak-management = {
      description = "Run flatpak management periodically";
      timerConfig = {
        OnCalendar = "daily";
        #OnCalendar = "*-*-* */6:00:00";
        OnBootSec = "1min";
        Persistent = "true";
      };
      wantedBy = ["timers.target"];
    };
}
