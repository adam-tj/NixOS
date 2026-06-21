{ config, ... }:

{
  sops.secrets."vaultwarden/domain" = {};
  sops.secrets."vaultwarden/admin_token" = { owner = "vaultwarden"; };

  services.vaultwarden = {
    enable = true;
    backupDir = "/home/vaultwarden/backup";
    environmentFile = config.sops.secrets."vaultwarden/admin_token".path;
    config = {
      DOMAIN = "https://${config.sops.placeholder."vaultwarden/domain"}";
      SIGNUPS_ALLOWED = true;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
    };
  };

  sops.templates."caddy-config.conf" = {
    owner = "caddy";
    content = ''
      ${config.sops.placeholder."vaultwarden/domain"} {
        encode zstd gzip
        reverse_proxy 127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up X-Real-IP {remote_host}
        }
      }
    '';
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      import ${config.sops.templates."caddy-config.conf".path}
    '';
  };

  systemd.services.caddy.after = [ "sops-nix.service" ];
}