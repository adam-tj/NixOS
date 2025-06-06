{
  lib,
  mpv-unwrapped,
  ocl-icd,
}:

mpv-unwrapped.wrapper {
  mpv = mpv-unwrapped.override { vapoursynthSupport = true; };
  extraMakeWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "/run/opengl-driver/lib:${lib.makeLibraryPath [ ocl-icd ]}"
  ];
}
