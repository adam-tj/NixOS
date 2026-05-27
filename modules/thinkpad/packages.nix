{ pkgs, pkgsUnstable, openmwPkgs, ... }:
{

  imports = [
    ../common/packages.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      intel-gpu-tools
      clinfo
    ]
    ++ (with pkgsUnstable; [
      ]);
}
