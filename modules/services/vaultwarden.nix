{ config, ... }:

{
  sops.secrets."vaultwarden/domain" = { };
  sops.secrets."vaultwarden/admin_token" = { };
  sops.secrets."vaultwarden/smtp_password" = { };
  sops.secrets."vaultwarden/smtp_username" = { };
  sops.secrets."vaultwarden/smtp_from" = { };
  sops.templates."vaultwarden-env" = {
    owner = "vaultwarden";
    content = ''
      ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/admin_token"}
      DOMAIN=https://${config.sops.placeholder."vaultwarden/domain"}
      SMTP_PASSWORD=${config.sops.placeholder."vaultwarden/smtp_password"}
      SMTP_USERNAME=${config.sops.placeholder."vaultwarden/smtp_username"}
      SMTP_FROM=${config.sops.placeholder."vaultwarden/smtp_from"}
    '';
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

  services.vaultwarden = {
    enable = true;
    backupDir = "/home/vaultwarden/backup";
    environmentFile = config.sops.templates."vaultwarden-env".path;
    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
      SMTP_HOST = "smtp.gmail.com";
      SMTP_PORT = 587;
      SMTP_SECURITY = "starttls";
      SMTP_FROM_NAME = "Adams Bitwarden";
    };
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      import ${config.sops.templates."caddy-config.conf".path}
    '';
  };

  systemd.services.caddy = {
    wants = [ "sops-nix.service" ];
    after = [ "sops-nix.service" ];
  };

  systemd.services.vaultwarden = {
    wants = [ "sops-nix.service" ];
    after = [ "sops-nix.service" ];
  };
}
