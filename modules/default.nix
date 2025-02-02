{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./rtx3060Nvidia.nix
    ./hyprland_stuff.nix
    ./nixldEnable.nix
  ];
}
