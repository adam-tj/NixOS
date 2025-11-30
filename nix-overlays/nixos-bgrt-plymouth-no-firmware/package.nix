{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  name = "nixos-bgrt-plymouth";
  version = "0-unstable-2024-10-25";

  src = fetchFromGitHub {
    repo = "plymouth-theme-nixos-bgrt";
    owner = "adam-tj";
    rev = "1f289613e57f585690695c3c1a2f667d1cccdcca";
    hash = "sha256-xe6/C54fz7T16FK7hjOQleuoeBEIdecRxt+fL2165nc=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/nixos-bgrt
    cp -r $src/{*.plymouth,images} $out/share/plymouth/themes/nixos-bgrt/
    substituteInPlace $out/share/plymouth/themes/nixos-bgrt/*.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/nixos-bgrt/images"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "BGRT theme with a spinning NixOS logo";
    homepage = "https://github.com/adam-tj/plymouth-theme-nixos-bgrt";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
