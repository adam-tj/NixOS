{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.username = "adam";
  home.homeDirectory = "/home/adam";

  # Slippi
  imports = [
    inputs.slippi.homeManagerModules.default
  ];

  nixpkgs.config = {
    permittedInsecurePackages = [
      #"freeimage-3.18.0-unstable-2024-04-18"
      #"mbedtls-2.28.10"
      #"mbedtls_2-2.28.10"
      #"qtwebengine-5.15.19"
      #"googleearth-pro-7.3.7.1155"
    ];
  };

  slippi-launcher = {
    enable = true;
    isoPath = "/home/adam/Games/ROMS/animelee.iso";
    rootSlpPath = "/home/adam/Games/Slippi";
    launchMeleeOnPlay = false;
    useMonthlySubfolders = true;
    enableJukebox = true;
    useNetplayBeta = false;
  };

  # Lutris + ProtonGE
  programs.lutris = {
    enable = true;
    #package = customLutris;
    extraPackages = with pkgs-unstable; [
      gamemode
    ];
    defaultWinePackage = pkgs-unstable.proton-ge-bin;
    protonPackages = [
      pkgs-unstable.proton-ge-bin
    ];
  };

  home.stateVersion = "24.11"; # Do not change this line.

  home.packages =
    with pkgs-unstable;
    [
      _7kaa
      rbw
      claude-code
      deluge
      devilutionx
      direnv
      discord
      distroshelf
      eden
      faugus-launcher
      gamemode
      gimp
      googleearth-pro
      heroic
      itch
      joplin-desktop
      libreoffice
      #libnotify
      mangohud
      mediainfo
      mediainfo-gui
      mesa-demos
      mesen
      nix-direnv
      nodejs
      neovim-qt-unwrapped
      nextcloud-client
      obs-studio
      #opencode
      piper
      protontricks
      qalculate-gtk
      qbittorrent
      quasselClient
      (retroarch.withCores (
        cores: with libretro; [
          beetle-psx-hw
          bsnes
          citra
          desmume
          dolphin
          mame
          mesen
          mgba
          mupen64plus
          pcsx2
          ppsspp
          sameboy
        ]
      ))
      remmina
      spotify
      starship-sf64
      steam-art-manager
      svp
      swi-prolog
      tor-browser
      tremotesf
      trgui-ng
      unsloth-desktop
      vesktop
      vlc
      vorbis-tools
      widevine-cdm
      winboat
      zapzap
      zoom-us
    ]
    ++ [
      inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.waterfox.packages.${pkgs.stdenv.hostPlatform.system}.waterfox-bin
      inputs.akizip.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ (with jetbrains; [
      #clion
      idea
      jdk
      #pycharm
      #rust-rover
    ])
    # ++ (with pkgs; [
    #plex-mpv-shim jellyfin-mpv-shim
    # ])
    # ++ (with pkgsWithMpvVs; [
    #   jellyfin-desktop
    #   mpv
    # ])
    ++ (with hunspellDicts; [
      de_DE
      en-gb-large
      en-us-large
      hu-hu
      it-it
      sv-se
    ])
    ++ (with nerd-fonts; [
      adwaita-mono
      dejavu-sans-mono
      hack
      jetbrains-mono
      liberation
      noto
      roboto-mono
      space-mono
      terminess-ttf
    ]);

  programs.ghostty = {
    enable = true;
    settings = {
      command = "${pkgs.fish}/bin/fish";
      theme = "Adwaita Dark";
    };
  };

  programs.vscodium = {
    enable = true;
    package = pkgs-unstable.vscodium-fhs;
    profiles.default.extensions = with pkgs-unstable.vscode-extensions; [
      github.copilot-chat
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/Console" = {
        shell = [ "fish" ];
      };

      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "caps:backspace" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
        num-workspaces = 4;
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };

      "org/gnome/desktop/wm/keybindings" = {
        #minimize = [ "<Super><Control>z" ];
        close = [ "<Super><Control>z" ];
        toggle-maximized = [ "<Super><Control>x" ];
        begin-move = [ ];
        begin-resize = [ ];
        toggle-fullscreen = [ "<Super>f" ];

        switch-to-workspace-last = [ ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];

        move-to-workspace-last = [ ];
        move-to-workspace-1 = [ "<Shift><Super>1" ];
        move-to-workspace-2 = [ "<Shift><Super>2" ];
        move-to-workspace-3 = [ "<Shift><Super>3" ];
        move-to-workspace-4 = [ "<Shift><Super>4" ];
      };

      "org/gnome/mutter/wayland/keybindings" = {
        restore-shortcuts = [ ];
      };

      "org/gnome/settings-daemon/plugins/housekeeping" = {
        donation-reminder-enabled = false;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        screenreader = [ ];
        magnifier = [ ];
        magnifier-zoom-in = [ ];
        magnifier-zoom-out = [ ];
      };

      "org/gnome/shell/keybindings" = {
        show-screenshot-ui = [ "<Super>Print" ];

        switch-to-application-1 = [ "<Super>q" ];
        switch-to-application-2 = [ "<Super>d" ];
        switch-to-application-3 = [ "<Super>z" ];
        switch-to-application-4 = [ "<Super>x" ];
        switch-to-application-5 = [ "<Super>c" ];
        switch-to-application-6 = [ "<Super>w" ];
        switch-to-application-7 = [ "<Super>e" ];
        switch-to-application-8 = [ "<Super>r" ];
        switch-to-application-9 = [ "<Super>Return" ];

        open-new-window-application-1 = [ "<Super><Shift>q" ];
        open-new-window-application-2 = [ "<Super><Shift>d" ];
        open-new-window-application-3 = [ "<Super><Shift>z" ];
        open-new-window-application-4 = [ "<Super><Shift>x" ];
        open-new-window-application-5 = [ "<Super><Shift>c" ];
        open-new-window-application-6 = [ "<Super><Shift>w" ];
        open-new-window-application-7 = [ "<Super><Shift>e" ];
        open-new-window-application-8 = [ "<Super><Shift>r" ];
        open-new-window-application-9 = [ "<Super><Shift>Return" ];
      };

      "com/github/amezin/ddterm" = {
        command = "custom-command";
        custom-command = "fish";
        ddterm-toggle-hotkey = [ "<Super>BackSpace" ];
      };
    };
  };

  home.file = {
    # Enable Widevine
    ".config/net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text =
      builtins.toJSON
        {
          #Path = "${pkgs.google-chrome}/share/google/chrome/WidevineCdm";
          Path = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm";
        };
    # ".waterfox/native-messaging-hosts" = {
    #   source = "${pkgs.firefoxpwa}/lib/mozilla/native-messaging-hosts";
    #   recursive = true;
    # };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 14d";
  };

  programs.home-manager.enable = true;

}
