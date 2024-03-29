{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./config.nix
    ../../base/configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    kernelParams = [ "8250.nr_uarts=1" "console=ttyAMA0,115200" "console=tty1" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];
  };

  networking = {
    hostName = config.hostname;
    wireless.enable = false;
  };
}
