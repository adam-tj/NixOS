{
  inputs.slippi.url = "github:lytedev/slippi-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  inputs.openmw-nix.url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
  #inputs.openmw-nix.follows = "nixpkgs";
  # inputs.nix-vscode-extensions = {
  #   url = "github:nix-community/nix-vscode-extensions?ref=master";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-25.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      slippi,
      openmw-nix,
      ...
    }@inputs:
    let
      svpOverlay = final: prev: {
        svp-with-mpv = final.callPackage ./nix-overlays/svp-with-mpv/package.nix { };
      };

      pkgsWithSVP = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [ svpOverlay ];
      };

      mpvWithVapoursynth = nixpkgs.mpv.override {
        vapoursynthSupport = true;
      };

      jellyfinMediaPlayerVapoursynth = nixpkgs.callPackage ./nix-overlays/jellyfin-media-player-vapoursynth.nix {
        mpvWithVapoursynth = mpvWithVapoursynth;
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
          specialArgs = { inherit inputs pkgsWithSVP; };
          modules = commonModules ++ [
            {
              nixpkgs.config.allowUnfree = true;
            }
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
                nix.gc.frequency = "daily";
              };
            }
          ];
        };

        # Desktop Configuration
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # specialArgs = { inherit inputs slippi pkgsWithSVP; };
          specialArgs = {
            inherit inputs pkgsWithSVP pkgsUnstable;
            openmwPkgs = openmw-nix.packages.x86_64-linux; };
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
                nix.gc.frequency = "daily";
              };
            }
          ];
        };
      };
    };
}
