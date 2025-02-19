{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  #  == Hardware Custom  ==

  hardware = {
  	cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
	enableRedistributableFirmware = true;
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
