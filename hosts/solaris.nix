# Host profile for the Solaris laptop.
{ lib, inputs, ... }:
{
  imports = [
    ../hardware/solaris-hardware.nix
    ../modules/common.nix
  ];

  networking.hostName = "Solaris";
  time.timeZone = "Australia/Sydney";

  scythesNixld.enable = true;
  hyprmisc.enable = true;
  hyprperks.enable = false;
  kdeStuff.enable = true;
  laptop.enable = true;
}
