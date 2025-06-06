{ stdenv
, lib
, callPackage
, copyDesktopItems
, svp-with-mpv
, jellyfin-media-player
}:

stdenv.mkDerivation rec {
  pname = "svp-and-jellyfin";
  version = "combined-1";

  # No source, just bundling two packages together
  dontUnpack = true;

  # These are the build inputs/packages we're combining
  nativeBuildInputs = [ copyDesktopItems ];

  # Depend on the existing derivations as inputs
  buildInputs = [ svp-with-mpv jellyfin-media-player ];

  # Post-install: make a place for both binaries and set symlinks
  postInstall = ''
    mkdir -p $out/bin
    # Link SVPManager from svp-with-mpv package
    ln -s ${svp-with-mpv}/bin/SVPManager $out/bin/SVPManager
    ln -s ${svp-with-mpv}/bin/mpv $out/bin/mpv

    # Link jellyfin media player binary
    ln -s ${jellyfin-media-player}/bin/jellyfinmediaplayer $out/bin/jellyfinmediaplayer

    # Copy desktop entries from both packages (optional but recommended)
    mkdir -p $out/share/applications
    cp ${svp-with-mpv}/share/applications/* $out/share/applications/ || true
    cp ${jellyfin-media-player}/share/applications/* $out/share/applications/ || true

    # Copy icons from both packages if needed
    mkdir -p $out/share/icons
    cp -r ${svp-with-mpv}/share/icons/* $out/share/icons/ || true
    cp -r ${jellyfin-media-player}/share/icons/* $out/share/icons/ || true
  '';

  meta = with lib; {
    description = "Combined package for SVP with MPV and Jellyfin Media Player, so you can enjoy smooth video AND a great media client";
    homepage = "https://www.svp-team.com/wiki/SVP:Linux and https://github.com/jellyfin/jellyfin-media-player";
    license = licenses.unfree; # SVP is unfree, Jellyfin is GPL but unfree is stricter, so safer
    maintainers = with maintainers; [ xddxdd jojosch ];
    platforms = [ "x86_64-linux" ];
  };
}
