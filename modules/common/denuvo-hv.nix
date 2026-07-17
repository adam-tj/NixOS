{ config, pkgs, ... }:

let
  moduleSource = ./denuvo/cpuid_fault_emulation;

  # 1. The inline kernel module derivation
  cpuidModule = pkgs.stdenv.mkDerivation {
    pname = "cpuid_fault_emulation";
    version = "0.1";
    src = moduleSource;

    nativeBuildInputs = config.boot.kernelPackages.kernel.moduleBuildDependencies;

    buildPhase = ''
      runHook preBuild
      make -C ${config.boot.kernelPackages.kernel.dev}/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/build M=$(pwd) modules
      runHook preBuild
    '';

    installPhase = ''
      runHook preInstall
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
  boot.extraModulePackages = if builtins.pathExists moduleSource then [ cpuidModule ] else [ ];

  # Add the toggle script to system packages
  environment.systemPackages = [ toggleHypervisor ];

  # 4. Allow passwordless sudo for the script
  security.sudo.extraRules = [{
    users = [ "adam" ];
    commands = [{
      command = "${toggleHypervisor}/bin/toggle-game-hv";
      options = [ "NOPASSWD" ];
    }];
  }];

  # 5. Shell aliases for easy launching
  # programs.bash.shellAliases = {
  #   game-on = "sudo toggle-game-hv on";
  #   game-off = "sudo toggle-game-hv off";
  # };

  # programs.zsh.shellAliases = {
  #   game-on = "sudo toggle-game-hv on";
  #   game-off = "sudo toggle-game-hv off";
  # };
}