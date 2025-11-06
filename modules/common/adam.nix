{ pkgs, pkgsWithSVP, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "Adam";
    packages = with pkgs; [
      appimage-run
      emulationstation-de
      gamemode
      hunspell
      irssi isoimagewriter
      jdk   jellyfin-mpv-shim jetbrains-toolbox
      libreoffice-qt lutris
      mangohud mediainfo mesa-demos mesen
      #(mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; })
      #( mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; extraMakeWrapperArgs = [ "--prefix" "LD_LIBRARY_PATH" ":" "/run/opengl-driver/lib:${lib.makeLibraryPath [ ocl-icd ]}" ]; } )
      piper plex-mpv-shim
      qbittorrent
          (retroarch.withCores (cores: with libretro; [
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
    ]))
      smplayer #svp
      vlc vorbis-tools vscodium
      wine



      #jellyfin-media-player.override { 
   #   mpv = svp.passthru.mpv; 
   #}

      #( jellyfin-mpv-shim.override { mpv = pkgs.mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; youtubeSupport = true; }; })
      #( jellyfin-mpv-shim.override { mpv = pkgs.svp.mpv; } )
      #( jellyfin-mpv-shim.override { mpv = mpv-unwrapped.wrapper { mpv = mpv-unwrapped.override { vapoursynthSupport = true; }; }; } )
    ] ++ (with pkgsWithSVP; [
      svp-with-mpv
      #jellyfin-with-svp.jellyfin-media-player
    ]) ++ (with kdePackages; [
      filelight
      kaccounts-integration
      kaccounts-providers
      kate
      kclock
      kolourpaint
    ]) ++ (with hunspellDicts; [
      cs-cz
      cs_CZ
      da-dk
      da_DK
      de-at
      de-ch
      de-de
      de_AT
      de_CH
      de_DE
      el-gr
      el_GR
      en-au
      en-au-large
      en-ca
      en-ca-large
      en-gb-ise
      en-gb-ize
      en-gb-large
      en-us
      en-us-large
      en_AU
      en_AU-large
      en_CA
      en_CA-large
      en_GB-ise
      en_GB-ize
      en_GB-large
      en_US
      en_US-large
      es-any
      es-ar
      es-bo
      es-cl
      es-co
      es-cr
      es-cu
      es-do
      es-ec
      es-es
      es-gt
      es-hn
      es-mx
      es-ni
      es-pa
      es-pe
      es-pr
      es-py
      es-sv
      es-uy
      es-ve
      es_ANY
      es_AR
      es_BO
      es_CL
      es_CO
      es_CR
      es_CU
      es_DO
      es_EC
      es_ES
      es_GT
      es_HN
      es_MX
      es_NI
      es_PA
      es_PE
      es_PR
      es_PY
      es_SV
      es_UY
      es_VE
      et-ee
      et_EE
      eu-es
      eu_ES
      fa-ir
      fa_IR
      fr-any
      fr-classique
      fr-moderne
      fr-reforme1990
      he-il
      he_IL
      hr-hr
      hr_HR
      hu-hu
      hu_HU
      id_ID
      id_id
      it-it
      it_IT
      ko-kr
      ko_KR
      nb-no
      nb_NO
      nl_NL
      nl_nl
      nn-no
      nn_NO
      pl-pl
      pl_PL
      pt-br
      pt-pt
      pt_BR
      pt_PT
      ro-ro
      ro_RO
      ru-ru
      ru_RU
      sk-sk
      sk_SK
      sv-fi
      sv-se
      sv_FI
      sv_SE
      th-th
      th_TH
      tok
      tr-tr
      tr_TR
      uk-ua
      uk_UA
    ])
    ;
  };  

  # Jellyfin vapoursynth
  # nixpkgs.overlays = [
  #   (self: super: {
  #     mpv-unwrapped =
  #       super.mpv-unwrapped.override { vapoursynthSupport = true; };
  #     youtubeSupport = true;
  #   })
  # ];
    

}
