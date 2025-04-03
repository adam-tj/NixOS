{ pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      (mpv-unwrapped.wrapper {
        mpv = mpv-unwrapped.override { vapoursynthSupport = true; };
        youtubeSupport = true;
      })

    ];
  };
}
