{ pkgs, pkgsUnstable, openmwPkgs, ... }:
{

  imports = [
    ../common/packages.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      kdiskmark
      intel-gpu-tools
      clinfo
    ]
    ++ (with pkgsUnstable; [
      ]);
}
