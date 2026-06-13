{
  inputs = {
    slippi.url = "github:lytedev/slippi-nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-kernel.url = "github:nixos/nixpkgs/5c2bc52fb9f8c264ed6c93bd20afa2ff5e763dce";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    openmw-nix.url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
    #nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    #sam-repo.url = "github:adam-tj/nixpkgs/steam-art-manager";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-kernel,
      nixos-hardware,
      home-manager,
      slippi,
      openmw-nix,
      ...
    }@inputs:
    let
      # 1. MOVE THIS TO THE TOP SO EVERYTHING BELOW CAN USE IT
      insecurePackagesList = import ./modules/common/whitelist-insecure-packages.nix;

      svpOverlay = final: prev: {
        svp-with-mpv = final.callPackage ./nix-overlays/svp-with-mpv/package.nix { };
      };
      bgrtOverlay = final: prev: {
        nixos-bgrt-plymouth-no-firmware =
          final.callPackage ./nix-overlays/nixos-bgrt-plymouth-no-firmware/package.nix
            { };
      };
      mpvVsOverlay = final: prev: {
        mpv-unwrapped = prev.mpv-unwrapped.override {
          vapoursynthSupport = true;
          vapoursynth = final.vapoursynth.withPlugins [
            final.vapoursynth-mvtools
          ];
        };

        jellyfin-desktop = prev.jellyfin-desktop.overrideAttrs (oldAttrs: {
          qtWrapperArgs = (oldAttrs.qtWrapperArgs or [ ]) ++ [
            "--prefix PYTHONPATH : ${
              final.vapoursynth.withPlugins [ final.vapoursynth-mvtools ]
            }/lib/python${final.python3.pythonVersion}/site-packages"
          ];
        });
      };

      openldapOverlay = (
        final: prev: {
          openldap = prev.openldap.overrideAttrs (_: {
            doCheck = !prev.stdenv.hostPlatform.isi686;
          });
        }
      );

      pkgsWithMpvVs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.permittedInsecurePackages = insecurePackagesList;
        overlays = [ mpvVsOverlay ];
      };

      pkgsWithSVP = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.permittedInsecurePackages = insecurePackagesList;
        overlays = [ svpOverlay ];
      };

      pkgsWithBgrt = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.permittedInsecurePackages = insecurePackagesList;
        overlays = [ bgrtOverlay ];
      };

      # 2. FIX: Insecure list applied directly to the global unstable instance
      pkgsUnstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.permittedInsecurePackages = insecurePackagesList;
      };

      commonModules = [
        home-manager.nixosModules.home-manager
      ];
    in
    {
      nixosConfigurations = {
        # Laptop Configuration
        thinkpad = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              pkgsWithSVP
              pkgsUnstable
              pkgsWithBgrt
              pkgsWithMpvVs
              ;
          };
          modules = commonModules ++ [
            ./hosts/thinkpad.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-l13
            {
              nixpkgs.overlays = [ openldapOverlay ];
              nixpkgs.config.permittedInsecurePackages = insecurePackagesList;
            }
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.adam = ./modules/thinkpad/home.nix;
                sharedModules = [
                  {
                    nixpkgs.overlays = [
                      mpvVsOverlay
                      openldapOverlay
                      svpOverlay
                    ];
                    nixpkgs.config.allowUnfree = true;
                    nixpkgs.config.permittedInsecurePackages = insecurePackagesList;
                  }
                ];
                extraSpecialArgs = {
                  inherit inputs pkgsWithMpvVs;
                  pkgs-unstable = pkgsUnstable; # Use the fixed instance
                };
              };
            }
          ];
        };

        # Desktop Configuration
        desktop = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              pkgsWithSVP
              pkgsUnstable
              nixpkgs-kernel
              pkgsWithMpvVs
              ;
            openmwPkgs = openmw-nix.packages.x86_64-linux;
          };
          modules = commonModules ++ [
            ./hosts/desktop.nix
            {
              nixpkgs.overlays = [ openldapOverlay ];
              nixpkgs.config.permittedInsecurePackages = insecurePackagesList;
            }
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.adam = ./modules/desktop/home.nix;
                sharedModules = [
                  {
                    nixpkgs.overlays = [
                      mpvVsOverlay
                      openldapOverlay
                      svpOverlay
                    ];
                    nixpkgs.config.allowUnfree = true;
                    nixpkgs.config.permittedInsecurePackages = insecurePackagesList;
                  }
                ];
                extraSpecialArgs = {
                  inherit inputs pkgsWithMpvVs;
                  pkgs-unstable = pkgsUnstable; # Use the fixed instance
                };
              };
            }
          ];
        };
      };
    };
}
