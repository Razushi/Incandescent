# Bunch of hyprland related things
{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    hyprmisc.enable = lib.mkEnableOption "Enables hyprland related miscellanea";
  };
  config = lib.mkIf config.hyprmisc.enable {
    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      withUWSM = false;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };

    programs.niri.enable = true;

    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman thunar-media-tags-plugin];

    services.displayManager.gdm.enable = true;

    # Needed for most file managers
    services.gvfs.enable = true;

    # Secret service called
    # services.gnome.gnome-keyring.enable = true;

    # Programs I use with Hyprland
    environment.systemPackages = with pkgs; [
      copyq
      dconf-editor
      file-roller
      font-awesome
      fuzzel
      grimblast
      flameshot
      hyprcursor
      hypridle
      hyprland-qtutils
      hyprlock
      hyprpaper
      hyprpicker
      hyprpolkitagent # Needs the style package to be added
      labwc
      mako
      networkmanagerapplet
      nomacs-qt6
      nsxiv
      nwg-look
      overskride
      pavucontrol
      playerctl
      qt6Packages.qt6ct
      libsForQt5.qt5ct
      swww # Wallpaper util
      swappy
      waybar
      xdg-desktop-portal-termfilechooser
      xwayland-satellite
      greybird # GTK theme, mainly for Thunar
      elementary-xfce-icon-theme # Icon theme, for GTK
      xfce.tumbler # For Thunar thumbnails
      quickshell
      inputs.dank-material-shell.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.dms-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # Hypothetically speaking, symlinks the plugins to /etc/hyprplugins/lib/
    environment.etc."hyprplugins/libhyprexpo".source =
      "${inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo}/lib/libhyprexpo.so";
    # environment.etc."hyprplugins/libhyprspace".source = "${pkgs.hyprlandPlugins.hyprspace}/lib/libhyprspace.so";
    environment.etc."hyprplugins/libhyprscrolling".source =
      "${inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling}/lib/libhyprscrolling.so";
  };
}
