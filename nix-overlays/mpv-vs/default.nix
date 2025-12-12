final:

let
  callOverride =
   path: attrs:
   import path (
     {
       inherit
         final
         ;
     }
     // attrs
   );

in
 { mpv-vapoursynth =
    (final.mpv-unwrapped.wrapper {
      mpv = final.mpv-unwrapped.override {
        vapoursynthSupport = true;
        vapoursynth = final.vapoursynth.withPlugins [ final.vapoursynth-mvtools ];
      };
    });
      }
