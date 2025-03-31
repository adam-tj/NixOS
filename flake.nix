{
  inputs.slippi.url = "github:lytedev/slippi-nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-24.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, slippi, ... }@inputs:
    let
      # Common parameters for both systems
      commonModules = [
        #       ./hosts/common.nix
        home-manager.nixosModules.home-manager
      ];
    in {
      nixosConfigurations = {
        # Laptop Configuration
        #       thinkpad = nixpkgs.lib.nixosSystem {
        #         system = "x86_64-linux";
        #         modules = commonModules ++ [
        # #           ./hosts/thinkpad/default.nix
        #           {
        # #             home-manager.users.yourname = import ./home/thinkpad/default.nix;
        #             # Laptop-specific home-manager settings
        #             home-manager.extraSpecialArgs = {
        #               inherit inputs;
        # #               isLaptop = true;
        #             };
        #           }
        #         ];
        #         specialArgs = { inherit inputs; };
        #       };

        # Desktop Configuration
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs slippi; };
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
