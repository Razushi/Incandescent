{ lib, pkgs, pkgs-unstable, config, ... }:
let
  pythonEnv =
    pkgs.python3.withPackages (ps:
      with ps;
      [
        pillow
        psutil
        numpy
        tqdm
        opencv4
      ]
      ++ lib.optionals (ps ? pycairo) [pycairo]
      ++ lib.optionals (ps ? pygobject3) [pygobject3]
      ++ lib.optionals (ps ? evdev) [evdev]
      ++ lib.optionals (ps ? material-color-utilities) [material-color-utilities]
      ++ lib.optionals (ps ? setproctitle) [setproctitle]
      ++ lib.optionals (ps ? loguru) [loguru]);
in {
  options.ii.niri.enable =
    lib.mkEnableOption "Illogical-Impulse Niri dependencies (quickshell/niri stack)";

  config = lib.mkIf config.ii.niri.enable {
    programs.niri.enable = lib.mkDefault true;
    programs.niri.package = lib.mkDefault pkgs-unstable.niri;

    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    services.geoclue2.enable = lib.mkDefault true;
    services.upower.enable = lib.mkDefault true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common.default = ["gtk"];
      config.niri.default = ["gnome" "gtk"];
    };

    environment.systemPackages = lib.mkAfter (
      with pkgs; [
        bc
        coreutils
        cliphist
        curl
        wget
        ripgrep
        jq
        xdg-user-dirs
        rsync
        git
        wl-clipboard
        libnotify
        wlsunset
        dunst
        polkit
        networkmanager
        gnome-keyring
        dolphin
        foot
        fish
        gum
        xwayland-satellite
        translate-shell
        kvantum
        hyprpicker
        songrec
        qt6ct
        kde-gtk-config
        breeze
        grim
        slurp
        swappy
        tesseract
        ffmpeg
        wf-recorder
        imagemagick
        brightnessctl
        ddcutil
        geoclue2
        swayidle
        upower
        pavucontrol
        playerctl
        libdbusmenu
        cava
        easyeffects
        ydotool
        wtype
        pythonEnv
      ]
      ++ lib.optionals (pkgs ? libdbusmenu-gtk3) [pkgs.libdbusmenu-gtk3]
      ++ lib.optionals (pkgs ? mission-center) [pkgs.mission-center]
      ++ lib.optionals (pkgs ? fuzzel) [pkgs.fuzzel]
      ++ lib.optionals (pkgs ? libqalculate) [pkgs.libqalculate]
      ++ (with pkgs-unstable; [
        quickshell
      ]
      ++ lib.optionals (pkgs-unstable ? mission-center) [pkgs-unstable.mission-center]
      ++ lib.optionals (pkgs-unstable ? uv) [pkgs-unstable.uv])
    );

    fonts.packages = lib.mkAfter (
      with pkgs; [
        material-symbols
      ]
      ++ lib.optionals (pkgs ? space-grotesk) [pkgs.space-grotesk]
      ++ lib.optionals (pkgs ? readex-pro) [pkgs.readex-pro]
      ++ lib.optionals (pkgs ? rubik) [pkgs.rubik]
      ++ lib.optionals (pkgs ? twemoji-color-font) [pkgs.twemoji-color-font]
    );
  };
}
