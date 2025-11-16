# Host profile for the Incandescent desktop.
{ lib, inputs, ... }:
{
  imports = [
    ../hardware/incandescent-hardware.nix
    ../modules/common.nix
  ];

  networking.hostName = "Incandescent";
  time.timeZone = "Australia/Sydney";

  scythesNixld.enable = true;
  hyprmisc.enable = true;
  hyprperks.enable = true;
  kdeStuff.enable = true;
  laptop.enable = false;
}
