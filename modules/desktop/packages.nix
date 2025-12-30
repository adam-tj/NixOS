#{ pkgs, pkgsUnstable, openmwPkgs, ... }:
{ pkgs, pkgsUnstable, ... }:
{

  imports = [
    ../common/packages_temporary_unstable.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      nix-ld
      r2modman
      tes3cmd
      openmw
      rocmPackages.clr.icd
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime
      mesa.opencl
      unigine-superposition
      unigine-valley

    ]
    ++ (with pkgsUnstable; [
#      openmw
#    ])
#    ++ (with openmwPkgs; [
#      delta-plugin
#      groundcoverify
#      momw-configurator
#      openmw-validator
#      s3lightfixes
#      umo
    ]);
}
