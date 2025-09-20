# Bunch of hyprland related things
{
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
    programs.hyprland.enable = true;

    # programs.niri.enable = true;

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman tumbler];

    # Needed for most file managers
    services.gvfs.enable = true;

    # Programs I use with Hyprland
    environment.systemPackages = with pkgs; [
      # niri
      xwayland-satellite
      anyrun
      file-roller

      # copyq
      clipse # swapped from copyq

      dconf-editor
      font-awesome
      fuzzel
      grimblast
      hyprcursor
      hypridle
      # hyprlandPlugins.hyprexpo # Hyprland plugins, requires some funny business
      # hyprlandPlugins.hyprspace # Not compatible with 0.47.x yet
      hyprlock
      hyprpaper
      hyprland-qtutils
      hyprpicker
      hyprpolkitagent # Needs the style package to be added
      polkit_gnome # Replacement for now
      mako
      networkmanagerapplet
      nomacs
      nwg-look
      overskride
      pavucontrol
      playerctl
      qt6ct
      swappy
      waybar

      # Set GTK, I'm using it for cursors rn.
      nwg-look

      # KDE stuff, mostly Dolphin stuff
      kdePackages.ark
      kdePackages.breeze
      kdePackages.breeze-icons
      kdePackages.dolphin
      kdePackages.ffmpegthumbs
      kdePackages.gwenview
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kservice
      kdePackages.okular
      kdePackages.qtimageformats
      kdePackages.qtstyleplugin-kvantum
      kdePackages.qtsvg
      kdePackages.qtwayland

      # XFCE stuff
      # xfce.xfce4-panel
    ];

    # Hypothetically speaking, symlinks the plugins to /etc/hyprplugins/lib/
    # environment.etc."hyprplugins/libhyprexpo".source = "${pkgs.hyprlandPlugins.hyprexpo}/lib/libhyprexpo.so";
    # environment.etc."hyprplugins/libhyprspace".source = "${pkgs.hyprlandPlugins.hyprspace}/lib/libhyprspace.so";
  };
}
