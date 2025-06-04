{ config, pkgs, ... }:

let
  # Create an overlay to modify packages
  customOverlays = [
    (self: super: {
      jellyfin-media-player = super.jellyfin-media-player.override {
        mpv = self.svp.passthru.mpv;
      };
    })
  ];
in {
  nixpkgs.overlays = customOverlays;
  
  environment.systemPackages = with pkgs; [
    svp             # SVP manager (required for interpolation)
    jellyfin-media-player  # Modified player using SVP's MPV
  ];

  # Optional: Autostart SVP Manager with display
  systemd.user.services.svp-manager = {
    enable = true;
    description = "SVP Manager";
    serviceConfig = {
      ExecStart = "${pkgs.svp}/bin/SVPManager";
      Restart = "on-failure";
    };
    wantedBy = [ "graphical-session.target" ];
  };
}