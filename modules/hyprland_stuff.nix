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
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
      networkmanagerapplet
      nomacs-qt6
      nsxiv
      nautilus # Needed for Niri file picker/chooser.
      nwg-look
      overskride
      pavucontrol
      playerctl
      qt6Packages.qt6ct
      libsForQt5.qt5ct
      swappy
      swww # Wallpaper util
      waybar
      xdg-desktop-portal-termfilechooser
      xwayland-satellite
      greybird # GTK theme, mainly for Thunar
      elementary-xfce-icon-theme # Icon theme, for GTK
      xfce.tumbler # For Thunar thumbnails
      # ----Dank Material Shell----
      quickshell
      inputs.dank-material-shell.packages.x86_64-linux.default
      inputs.dms-cli.packages.x86_64-linux.default # CLI for DankMaterialShell
    ];

    # Hypothetically speaking, symlinks the plugins to /etc/hyprplugins/lib/
    environment.etc."hyprplugins/libhyprexpo".source = "${inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo}/lib/libhyprexpo.so";
    # environment.etc."hyprplugins/libhyprspace".source = "${pkgs.hyprlandPlugins.hyprspace}/lib/libhyprspace.so";
    environment.etc."hyprplugins/libhyprscrolling".source = "${inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling}/lib/libhyprscrolling.so";
  };
}
