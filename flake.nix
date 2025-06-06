{
  inputs.slippi.url = "github:lytedev/slippi-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  # inputs.nix-vscode-extensions = {
  #   url = "github:nix-community/nix-vscode-extensions?ref=master";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-25.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, slippi
    , ... }@inputs:
    let
      # Common parameters for both systems
      commonModules = [
        # ./hosts/common.nix
        home-manager.nixosModules.home-manager
      ];

      # Define your custom overlay for SVP and MPV
      # This function takes 'final' (the final package set) and 'prev' (the previous package set)
      myCustomSvpOverlay = final: prev: {
        # Call your package.nix file using prev.callPackage.
        # This will make the 'svp-with-mpv' and 'mpvWithSVP' derivations
        # available in the 'pkgs' set of your system.
        inherit (prev.callPackage ./package.nix {}) svp-with-mpv mpvWithSVP;
      };

    in {
      # Make your custom overlay available as part of this flake's outputs.
      # You can now reference this overlay from other flakes or your system config.
      overlays.default = myCustomSvpOverlay;

      nixosConfigurations = {
        # Laptop Configuration
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = commonModules ++ [
            {
              nixpkgs.config.allowUnfree = true;
              # Apply your custom SVP overlay here for the thinkpad configuration
              nixpkgs.overlays = [ myCustomSvpOverlay ];
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
                    slippi-launcher.isoPath =
                      "/home/adam/Games/ROMS/animelee.iso";
                    slippi-launcher.rootSlpPath = "/home/adam/Games/Slippi";
                    slippi-launcher.launchMeleeOnPlay = false;
                    slippi-launcher.useMonthlySubfolders = true;
                    slippi-launcher.enableJukebox = true;
                    slippi-launcher.useNetplayBeta = false;
                    # slippi-launcher.netplayVersion = "3.4.0";
                    # slippi-launcher.netplayHash =
                    #   "sha256-iCBdlcBPSRT8m772sqI+gSfNmVNAug0SfkSwVUE6+fE=";
                    # slippi-launcher.playbackVersion = "3.4.0";
                    # slippi-launcher.playbackHash =
                    #   "sha256-iCBdlcBPSRT8m772sqI+gSfNmVNAug0SfkSwVUE6+fE=";
                  }
                ];
              };
            }
          ];
        };

        # Desktop Configuration
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs slippi; };
          modules = commonModules ++ [
            {
              # Apply your custom SVP overlay here for the desktop configuration
              nixpkgs.overlays = [ myCustomSvpOverlay ];
            }
            ./hosts/desktop.nix
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
                    slippi-launcher.isoPath =
                      "/home/adam/Games/ROMS/animelee.iso";
                    slippi-launcher.rootSlpPath = "/home/adam/Games/Slippi";
                    slippi-launcher.launchMeleeOnPlay = false;
                    slippi-launcher.useMonthlySubfolders = true;
                    slippi-launcher.enableJukebox = true;
                    slippi-launcher.useNetplayBeta = false;
                  }
                ];
              };
            }
          ];
        };
      };
    };
}
