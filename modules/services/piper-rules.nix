# { pkgs, inputs, ... }:
# let
#   unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
# in {
#   nixpkgs.overlays = [
#     (final: prev: {
#       libratbag = unstable.libratbag;  # Replace stable libratbag with unstable
#       ratbagd = unstable.ratbagd;      # Ensure ratbagd comes from unstable
# #      piper = unstable.piper;         # Optional: Also use unstable piper
#     })
#   ];

#   services.ratbagd.enable = true;  # Will now use the unstable version
# }

{ services.ratbagd.enable = true; }