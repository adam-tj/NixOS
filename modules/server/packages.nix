{ pkgs, pkgsUnstable, openmwPkgs, inputs, ... }:
#{ pkgs, pkgsUnstable, ... }:
{

  imports = [
    ../common/packages.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
    ];
}
