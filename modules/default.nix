{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./rtx3060Nvidia.nix
    ./hyprland_stuff.nix
    ./kde_stuff.nix
    ./nixldEnable.nix
    ./codex.nix
    ./laptop.nix
  ];
}
