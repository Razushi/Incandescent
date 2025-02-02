# Module to enable nix-ld and a bunch of stuff it may need
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    scythesNixld.enable = lib.mkEnableOption "Enables scythe's nix-ld config";
  };
  config = lib.mkIf config.scythesNixld.enable {
    # Run the binaries, in theory
    # Doesn't fkin work, xkb fails... no config?
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libGL
        xorg.libxcb
        pulseaudio
        libxkbcommon
        xkeyboard_config
      ];
    };
  };
}
