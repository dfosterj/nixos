# Nix Setup

This is a NixOS setup that tries to live all outside of whats installed and setup via NixOS installer.
workstation uniq hardware setups found in ./hardware
To be modular and linux fluid this setup uses separate repos for home-manager and dotfiles.

## After fresh install

git clone this repo to /etc/nixos/custom (or whatever name you want)
add custom/custom-configuration.nix to imports section of /etc/nixos/configuration.nix
keep only bootloader options in configuration.nix and delete rest.
refer to example-configuration.nix below.

run setup.sh to add unstable channel and to create /etc/nixos/host-variables.nix
or do those steps manually.

add home-manger repo to $HOME/.config/home-manager
add dotfile repot to $HOME/.dotfiles (run install.sh)

sudo nixos-rebuild switch --flake /etc/nixos/custom#default --impure

## example /etc/nixos/host-variables.nix
```
{
  workstationName = "myworkstation";
}
```


## example /etc/nixos/configuration.nix
```
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./custom/configuration-custom.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."".device = "";
  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."".keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices."".keyFile = "/boot/crypto_keyfile.bin";
}

