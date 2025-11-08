{ pkgs, pkgsUnstable, ... }:
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
    ]
    ++ (with pkgsUnstable; [
      openmw
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
