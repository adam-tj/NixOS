{ pkgs, pkgsUnstable, openmwPkgs, ... }:
#{ pkgs, pkgsUnstable, ... }:
{

  imports = [
    ../common/packages_temporary_unstable.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      alpaca
      nix-ld
      r2modman
      tes3cmd
      openmw
      (pkgs.ollama.override {
         acceleration = "rocm";
       })
      rocmPackages.clr.icd
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime
      mesa.opencl
      unigine-superposition
      unigine-valley

    ]
#    ++ (with pkgsUnstable; [
#      openmw
#    ])
    ++ (with openmwPkgs; [
      delta-plugin
      groundcoverify
      momw-configurator
      openmw-validator
      s3lightfixes
      umo
    ]);

    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      loadModels = [
        "gemma3:12b"
        "deepseek-r1:14b"
      ];
    };
}
