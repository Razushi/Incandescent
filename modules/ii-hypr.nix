{ lib, pkgs, pkgs-unstable, inputs, config, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPortal = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
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
  options.ii.hypr.enable =
    lib.mkEnableOption "Illogical-Impulse Hyprland dependencies (quickshell/Hyprland stack)";

  config = lib.mkIf config.ii.hypr.enable {
    programs.hyprland.enable = lib.mkDefault true;
    programs.hyprland.package =
      lib.mkDefault inputs.hyprland.packages.${system}.hyprland;

    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    services.geoclue2.enable = lib.mkDefault true;
    services.upower.enable = lib.mkDefault true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        hyprlandPortal
      ];
      config.common.default = ["hyprland" "gtk"];
      config.hyprland.default = ["hyprland" "gtk"];
    };

    environment.systemPackages = lib.mkAfter (
      with pkgs; [
        bc
        coreutils
        curl
        wget
        ripgrep
        jq
        xdg-user-dirs
        rsync
        yq-go
        cliphist
        wl-clipboard
        fuzzel
        wlogout
        hypridle
        hyprlock
        hyprpicker
        swappy
        grim
        slurp
        wf-recorder
        tesseract
        translate-shell
        songrec
        libqalculate
        easyeffects
        pavucontrol
        brightnessctl
        ddcutil
        geoclue2
        playerctl
        cava
        ydotool
        wtype
        pythonEnv
      ]
      ++ lib.optionals (pkgs ? hyprpaper) [pkgs.hyprpaper]
      ++ lib.optionals (pkgs ? hyprcursor) [pkgs.hyprcursor]
      ++ lib.optionals (pkgs ? hyprland-qtutils) [pkgs.hyprland-qtutils]
      ++ lib.optionals (pkgs ? hyprshot) [pkgs.hyprshot]
      ++ lib.optionals (pkgs ? pavucontrol-qt) [pkgs.pavucontrol-qt]
      ++ lib.optionals (pkgs ? libnotify) [pkgs.libnotify]
      ++ lib.optionals (pkgs ? uv) [pkgs.uv]
      ++ (with pkgs-unstable; [
        quickshell
      ]
      ++ lib.optionals (pkgs-unstable ? hyprshot) [pkgs-unstable.hyprshot]
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
