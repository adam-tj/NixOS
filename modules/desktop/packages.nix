{ pkgs, pkgsUnstable, openmwPkgs, inputs, ... }:
#{ pkgs, pkgsUnstable, ... }:
{

  imports = [
    ../common/packages.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      #bitwarden-desktop
      #inputs.sam-repo.legacyPackages.${pkgs.stdenv.hostPlatform.system}.steam-art-manager
      #alpaca
      #r2modman
      #tes3cmd
      #openmw
#      (pkgs.ollama.override {
#         acceleration = "rocm";
#       })
#      rocmPackages.clr.icd
#      rocmPackages.clr
#      rocmPackages.rocminfo
#      rocmPackages.rocm-runtime
#      mesa.opencl
    ]
#    ++ (with pkgsUnstable; [
#      openmw
#    ])
    ++ (with openmwPkgs; [
      #delta-plugin
      #groundcoverify
      #momw-configurator
      #openmw-validator
      #s3lightfixes
      #umo
    ]);

    services.ollama = {
     enable = true;
     package = pkgs.ollama-rocm;
     loadModels = [
       "gemma4:e4b"
       "deepseek-r1:14b"
       "llama3.2:3b"
     ];
    };
}
