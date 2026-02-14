{
  inputs = {
    slippi.url = "github:lytedev/slippi-nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-kernel.url = "github:nixos/nixpkgs/5c2bc52fb9f8c264ed6c93bd20afa2ff5e763dce";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    openmw-nix.url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
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
      nix-cachyos-kernel,
      #sam-repo,
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
        mpv-unwrapped = prev.mpv-unwrapped.override {
            vapoursynthSupport = true;
            vapoursynth = final.vapoursynth.withPlugins [
              final.vapoursynth-mvtools
            ];
          };

        jellyfin-desktop = prev.jellyfin-desktop.overrideAttrs (oldAttrs: {
          qtWrapperArgs = (oldAttrs.qtWrapperArgs or []) ++ [
            "--prefix PYTHONPATH : ${final.vapoursynth.withPlugins [ final.vapoursynth-mvtools ]}/lib/python${final.python3.pythonVersion}/site-packages"
            ];
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
          specialArgs = { inherit inputs pkgsWithSVP pkgsUnstable pkgsWithBgrt pkgsWithMpvVs; };
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
        desktop = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          # specialArgs = { inherit inputs slippi pkgsWithSVP; };
          specialArgs = {
            inherit inputs pkgsWithSVP pkgsUnstable nix-cachyos-kernel nixpkgs-kernel pkgsWithMpvVs;
            #inherit inputs sam-repo pkgsWithSVP pkgsUnstable nix-cachyos-kernel nixpkgs-kernel pkgsWithMpvVs;
            openmwPkgs = openmw-nix.packages.x86_64-linux;
          };
          modules = commonModules ++ [
            ./hosts/desktop.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.adam = ./modules/desktop/home.nix;
                extraSpecialArgs = {
                  inherit inputs pkgsWithMpvVs;
                  pkgs-unstable = import nixpkgs-unstable {
                    system = "x86_64-linux";
                    config.allowUnfree = true;
                  };
                };
              };
            }
          ];
        };
      };
    };
}
