{ config, pkgs, ... }:

let
  # The absolute path outside of your Git repository
  moduleSource = /home/adam/Linux/denuvo/cpuid_fault_emulation;

  # 1. The optimized kernel module derivation
  cpuidModule = config.boot.kernelPackages.kernel.stdenv.mkDerivation {
    pname = "cpuid_fault_emulation";
    version = "0.1";
    src = moduleSource;

    # Kernel modules must not be compiled with position-independent code
    hardeningDisable = [ "pic" ];

    nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

    buildPhase = ''
      runHook preBuild
      # This mimics 'dkms build' by pointing directly to the Nix store kernel headers
      make -C ${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build M=$(pwd) modules
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      # This mimics 'dkms install' by placing the driver in the system's extra modules path
      install -D cpuid_fault_emulation.ko $out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/extra/cpuid_fault_emulation.ko
      runHook postInstall
    '';
  };

  # 2. The toggle script wrapper
  toggleHypervisor = pkgs.writeShellScriptBin "toggle-game-hv" ''
    if [ "$1" = "on" ]; then
      echo "Disabling KVM and loading game hypervisor..."
      modprobe -r kvm_amd kvm
      modprobe cpuid_fault_emulation
    elif [ "$1" = "off" ]; then
      echo "Unloading game hypervisor and restoring KVM..."
      modprobe -r cpuid_fault_emulation
      modprobe kvm_amd kvm
    else
      echo "Usage: toggle-game-hv [on|off]"
      exit 1
    fi
  '';
in
{
  # 3. Only build the module if the folder actually exists
  boot.extraModulePackages = [ cpuidModule ];

  # Add the toggle script to system packages
  environment.systemPackages = [ toggleHypervisor ];

  # 4. Allow passwordless sudo for the script
  security.sudo.extraRules = [
    {
      users = [ "adam" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/toggle-game-hv";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
