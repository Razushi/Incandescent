# Bunch of hyprland related things
{
  inputs,
  pkgs,
  pkgs-unstable,
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
    programs.niri.package = pkgs-unstable.niri;

    programs.dank-material-shell = {
      enable = true;

      systemd = {
        enable = false;             # Systemd service for auto-start
        restartIfChanged = false;   # Auto-restart dms.service when dms-shell changes
      };
      
      # Core features
      enableSystemMonitoring = false;     # System monitoring widgets (dgop)
      enableVPN = false;                  # VPN management widget
      enableDynamicTheming = false;       # Wallpaper-based theming (matugen)
      enableAudioWavelength = false;      # Audio visualizer (cava)
      enableCalendarEvents = false;       # Calendar integration (khal)
      enableClipboardPaste = false;       # Pasting from the clipboard history (wtype)
    };

    programs.qtengine = {
      enable = true;
      
      config = {
        theme = {
          # colorScheme = "/home/scythe/.local/share/color-schemes/DankMatugen.colors";
          iconTheme = "breeze-dark";
          style = "kvantum";

          font = {
            family = "Atkinson Hyperlegible Next";
            size = 12;
            weight = -1;
          };

          fontFixed = {
            family = "Atkinson Hyperlegible Mono";
            size = 12;
            weight = -1;
          };
        };

        misc = {
          singleClickActivate = false;
          menusHaveIcons = true;
          shortcutsForContextMenus = true;
        };
      };
    };

    services.xserver.displayManager.gdm.enable = true;

    # Needed for most file managers
    services.gvfs.enable = true;

    # Secret service called
    # services.gnome.gnome-keyring.enable = true;

    # Programs I use with Hyprland
    environment.systemPackages = with pkgs; [
      adw-gtk3 # Mfw
      dconf-editor
      file-roller
      font-awesome
      fuzzel
      pkgs-unstable.vicinae
      grimblast
      pkgs-unstable.hyprcursor
      pkgs-unstable.hypridle
      pkgs-unstable.hyprlauncher
      pkgs-unstable.hyprsysteminfo
      pkgs-unstable.hyprsunset
      pkgs-unstable.hyprpwcenter
      pkgs-unstable.hyprshutdown
      pkgs-unstable.hyprland-qtutils
      pkgs-unstable.hyprlock
      pkgs-unstable.hyprpaper
      pkgs-unstable.hyprpicker
      pkgs-unstable.hyprpolkitagent # Needs the style package to be added
      labwc
      networkmanagerapplet
      nomacs-qt6
      nsxiv
      nwg-look
      overskride
      pavucontrol
      playerctl
      awww # Wallpaper util
      swappy
      waybar
      xdg-desktop-portal-termfilechooser
      xwayland-satellite
      greybird # GTK theme, mainly for Thunar
      elementary-xfce-icon-theme # Icon theme, for GTK
      matugen # Color theme gen, billions must be themed
    ];
  };
}
