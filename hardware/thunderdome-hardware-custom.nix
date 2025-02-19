{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # == Extra Boot ==
  boot = {
    # == gaming ==
    extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
    # connect xbox controller
  };

##  == Hardware Custom  ==

  hardware = {
  	cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
	enableRedistributableFirmware = true;
    opengl.driSupport32Bit = true;
    nvidia-container-toolkit.enable = true;
	steam-hardware.enable = true;
    xpadneo.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
   hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  # == Bluetooth ==
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; settings.General = {
      experimental = true; # show battery
      Privacy = "device";
      JustWorksRepairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };
  services.blueman.enable = true;
}
