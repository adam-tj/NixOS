{ pkgs, pkgsUnstable, openmwPkgs, ... }:
{

  imports = [
    ../common/packages.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      nix-ld
      r2modman
      tes3cmd
      openmw

      unigine-superposition
      unigine-valley

    ]
    ++ (with pkgsUnstable; [
#      openmw
    ])
    ++ (with openmwPkgs; [
      delta-plugin
      groundcoverify
      momw-configurator
      openmw-validator
      s3lightfixes
      umo
    ]);
}
