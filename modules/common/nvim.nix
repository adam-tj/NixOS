{ pkgsUnstable, ... }:

{
  programs.neovim = {
   enable = true;
   defaultEditor = true;
   plugins = [
     pkgsUnstable.vimPlugins.astroui pkgsUnstable.vimPlugins.astrotheme pkgsUnstable.vimPlugins.astrolsp pkgsUnstable.vimPlugins.astrocore
  ];
};

}
