{ config, ... }:

{
  sops.secrets."duckdns/token" = { };

  services.duckdns = {
    enable = true;
    domains = [ "adamkista" ]; # Note: just the subdomain prefix, or your full domain depending on module version
    tokenFile = config.sops.secrets."duckdns/token".path;
  };
}
