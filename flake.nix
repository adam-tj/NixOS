{
  inputs = {
    slippi.url = "github:lytedev/slippi-nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    openmw-nix.url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
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
      mpvVsOverlay = final: prev: {
          mpv-vs =
              (final.mpv-unwrapped.wrapper {
                  mpv = final.mpv-unwrapped.override {
                  vapoursynthSupport = true;
                  vapoursynth = final.vapoursynth.withPlugins [ final.vapoursynth-mvtools ];
              };
          });
      };

      pkgsWithMpvVs = import nixpkgs {
       system = "x86_64-linux";
       config.allowUnfree = true;
       overlays = [ mpvVsOverlay ];
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
          specialArgs = { inherit inputs pkgsWithSVP pkgsUnstable pkgsWithBgrt; };
          modules = commonModules ++ [
            ./hosts/thinkpad.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-l13
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
            inherit inputs pkgsWithSVP pkgsUnstable nix-cachyos-kernel pkgsWithMpvVs;
            openmwPkgs = openmw-nix.packages.x86_64-linux;
          };
          modules = commonModules ++ [
            ./hosts/desktop.nix
            #            ./modules/common/slippi.nix
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
