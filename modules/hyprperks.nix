{ lib, pkgs, config, ... }:
let
  appearanceScript =
    pkgs.writeShellScript "hyprperks-appearance" ''
      set -euo pipefail

      if [ -z "''${DBUS_SESSION_BUS_ADDRESS-}" ]; then
        exit 0
      fi

      ${pkgs.glib.bin}/bin/gsettings set org.gnome.desktop.interface cursor-theme 'XCursor-Pro-Dark'
      ${pkgs.glib.bin}/bin/gsettings set org.gnome.desktop.interface cursor-size 24
      ${pkgs.glib.bin}/bin/gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
      ${pkgs.glib.bin}/bin/gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
      ${pkgs.glib.bin}/bin/gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
      ${pkgs.glib.bin}/bin/gsettings set org.gnome.desktop.interface font-name 'Lato'

      ${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 || true
    '';

in
{
  options.hyprperks.enable = lib.mkEnableOption "Enable Hyprperks-specific runtime requirements";

  config = lib.mkIf config.hyprperks.enable {
    environment.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };

    environment.extraInit = ''
      export QML2_IMPORT_PATH=${pkgs.qt6.qt5compat}/lib/qt-6/qml''${QML2_IMPORT_PATH:+:$QML2_IMPORT_PATH}
    '';

    environment.systemPackages = lib.mkAfter (with pkgs; [
      adw-gtk3
      hyprpolkitagent
      matugen
      papirus-icon-theme
      psmisc
      quickshell
      walker
      wallust
      qt6.qt5compat
      copyq
    ]);

    fonts.packages = lib.mkAfter (with pkgs; [
      lato
      material-symbols
    ]);

    systemd.user.services.hyprpolkitagent = {
      description = "Hyprland Polkit agent";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent";
        Restart = "on-failure";
      };
    };

    systemd.user.services.copyq = {
      description = "CopyQ clipboard daemon";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.copyq}/bin/copyq --start-server";
        Restart = "on-failure";
      };
    };

    systemd.user.services.hyprperks-appearance = {
      description = "Apply Hyprperks GNOME/KDE appearance defaults";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = appearanceScript;
      };
    };
  };
}
