{ pkgs-unstable, pkgsWithMpvVs, ... }:

{
  imports = [
    ../common/home.nix
  ];

  home.packages =
    (with pkgs-unstable; [
      r2modman
      vapoursynth
      vapoursynth-mvtools
      zapzap
    ])
    ++ (with pkgsWithMpvVs; [
      jellyfin-mpv-shim
      jellyfin-desktop
      mpv
      celluloid
    ]);

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "helium.desktop" # Super+Q
        "vesktop.desktop" # Super+D
        "chrome-gdfaincndogidkdcdkhapmbffkckdkhn-Default.desktop" # Super+Z
        "chrome-fmpnliohjhemenmnlpbfagaolkdacoja-Default.desktop" # Super+X
        "codium.desktop" # Super+C
        "com.rtosta.zapzap.desktop" # Super+W
        "org.gnome.Nautilus.desktop" # Super+E
        "intellij-idea.desktop" # Super+R
        "com.mitchellh.ghostty.desktop" # Super+Enter
      ];
    };
  };

}
