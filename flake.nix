{
  inputs = {
    slippi.url = "github:lytedev/slippi-nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    openmw-nix.url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
  };
};

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      slippi,
      openmw-nix,
      chaotic,
      nix-cachyos-kernel,
      ...
    }@inputs:
    let
      svpOverlay = final: prev: {
        svp-with-mpv = final.callPackage ./nix-overlays/svp-with-mpv/package.nix { };
      };
      bgrtOverlay = final: prev: {
        nixos-bgrt-plymouth-no-firmware = final.callPackage ./nix-overlays/nixos-bgrt-plymouth-no-firmware/package.nix { };
      };

#      jmpVsOverlay = final: prev: {
#        jellyfin-media-player-vs = final.callPackage ./nix-overlays/jellyfin-media-player-vapoursynth/jellyfin-media-player-vapoursynth.nix { };
#        mpvWithVapoursynth = prev.mpv-unwrapped.override {
#          vapoursynthSupport = true;
#          };
#      };

      jmpVsOverlay = final: prev:
        let
          # Define the custom MPV package first, using 'prev' (the current package set)
          mpvWithVapoursynth = (prev.mpv-unwrapped.wrapper {
            mpv = prev.mpv-unwrapped.override {
              vapoursynthSupport = true;
            };
          });
        in
        {
          jellyfin-media-player-vs = final.libsForQt5.callPackage ./nix-overlays/jellyfin-media-player-vapoursynth/jellyfin-media-player-vapoursynth.nix {
            inherit mpvWithVapoursynth;

            # Explicitly pass required top-level functions/hooks
            wrapQtAppsHook = final.libsForQt5.wrapQtAppsHook;

            # Explicitly pass Qt5 dependencies (to fix the previous 'qtbase' error)
            qtbase = final.libsForQt5.qtbase;
            qtwayland = final.libsForQt5.qtwayland;
            qtwebchannel = final.libsForQt5.qtwebchannel;
            qtwebengine = final.libsForQt5.qtwebengine;
            qtx11extras = final.libsForQt5.qtx11extras;
          };
        };


      pkgsWithSVP = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [ svpOverlay ];
      };

      pkgsWithBgrt = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [ bgrtOverlay ];
      };

      pkgsWithJmpvs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [ jmpVsOverlay ];
      };

      pkgsUnstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      # Common parameters for both systems
      commonModules = [
        #       ./hosts/common.nix
        home-manager.nixosModules.home-manager
      ];
    in
    {
      nixosConfigurations = {
        # Laptop Configuration
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs pkgsWithSVP pkgsUnstable pkgsWithJmpvs pkgsWithBgrt; };
          modules = commonModules ++ [
            ./hosts/thinkpad.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-l13
            chaotic.nixosModules.nyx-cache
            chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.adam = ./modules/thinkpad/home.nix;
              home-manager.extraSpecialArgs = {
                pkgs-unstable = import nixpkgs-unstable {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
              };

            }
            {
              home-manager.users.adam = {
                imports = [
                  slippi.homeManagerModules.default
                  {
                    slippi-launcher.isoPath = "/home/adam/Games/ROMS/animelee.iso";
                    slippi-launcher.rootSlpPath = "/home/adam/Games/Slippi";
                    slippi-launcher.launchMeleeOnPlay = false;
                    slippi-launcher.useMonthlySubfolders = true;
                    slippi-launcher.enableJukebox = true;
                    slippi-launcher.useNetplayBeta = false;
                  }
                ];
                # Garbage collection
                nix.gc.automatic = true;
                nix.gc.options = "--delete-older-than 10d";
                nix.gc.dates = "daily";
              };
            }
          ];
        };

        # Desktop Configuration
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # specialArgs = { inherit inputs slippi pkgsWithSVP; };
          specialArgs = {
            inherit inputs pkgsWithSVP pkgsUnstable pkgsWithJmpvs nix-cachyos-kernel;
            openmwPkgs = openmw-nix.packages.x86_64-linux;
          };
          modules = commonModules ++ [
            ./hosts/desktop.nix
            chaotic.nixosModules.nyx-cache
            chaotic.nixosModules.nyx-overlay
            chaotic.nixosModules.nyx-registry
            #            ./modules/common/slippi.nix

#              nixpkgs.overlays = [
#                (final: prev: {
#                  jellyfin-media-player = prev.jellyfin-media-player.override {
#                    # 2. OVERRIDE the 'mpv' input of jellyfin-media-player
#                    # This explicitly tells the jellyfin package to use your custom mpv
#                    mpv = chaotic.packages.${final.system}.mpv-vapoursynth;
#                  };
#                })
#              ];

            #(
            #  { pkgs, ... }:
            #  {
            #    nixpkgs.overlays = [ nix-cachyos-kernel.overlay ];
            #    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
            #  }
            #)
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.adam = ./modules/desktop/home.nix;
              home-manager.extraSpecialArgs = {
                pkgs-unstable = import nixpkgs-unstable {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
              };

            }
            {
              home-manager.users.adam = {
                imports = [
                  slippi.homeManagerModules.default
                  {
                    slippi-launcher.isoPath = "/home/adam/Games/ROMS/animelee.iso";
                    slippi-launcher.rootSlpPath = "/home/adam/Games/Slippi";
                    slippi-launcher.launchMeleeOnPlay = false;
                    slippi-launcher.useMonthlySubfolders = true;
                    slippi-launcher.enableJukebox = true;
                    slippi-launcher.useNetplayBeta = false;
                  }
                ];
                nix.gc.automatic = true;
                nix.gc.options = "--delete-older-than 10d";
                nix.gc.dates = "daily";
              };
            }
          ];
        };
      };
    };
}
