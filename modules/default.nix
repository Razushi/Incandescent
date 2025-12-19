{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./rtx3060Nvidia.nix
    ./hyprland_stuff.nix
    ./hyprperks.nix
    ./ii-hypr.nix
    ./ii-niri.nix
    ./kde_stuff.nix
    ./nixldEnable.nix
    ./laptop.nix
  ];
}
