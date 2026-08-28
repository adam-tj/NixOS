{ wg-easy, ... }:

wg-easy.nixosModules.wg-easy
        {
          services.wg-easy = {
            enable = true;
            port = 51821;
            host = "0.0.0.0";
          };
        }
