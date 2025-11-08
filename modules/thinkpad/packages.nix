{ pkgs, pkgsUnstable, openmwPkgs, ... }:
{

  imports = [
    ../common/packages.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
    ]
    ++ (with pkgsUnstable; [
      ]);
}
