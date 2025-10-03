{ pkgs, ... }:

{
  nixpkgs.config.joypixels.acceptLicense = true;

  fonts.packages =
    with pkgs;
    [
      anonymousPro
      fira-code
      fira-code-symbols
      font-awesome
      jetbrains-mono
      joypixels
      lato
      liberation_ttf
      monaspace
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      noto-fonts-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-monochrome-emoji
      liberation_ttf
      openmoji-color
      openmoji-black
      open-sans
      roboto
      roboto-mono
      ubuntu_font_family
    ] ++     builtins.filter lib.isDerivation (builtins.attrValues nerd-fonts)
;

    
}
