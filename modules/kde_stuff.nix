# Mostly just what's needed to get going with Dolphin.
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    kdeStuff.enable = lib.mkEnableOption "Enables Dolphin and other KDE misc";
  };
  config = lib.mkIf config.kdeStuff.enable {
    environment.systemPackages = with pkgs; [
      # Bunch of Dolphin stuff
      kdePackages.ark
      kdePackages.baloo
      kdePackages.baloo-widgets
      kdePackages.breeze-icons
      kdePackages.breeze-icons
      kdePackages.dolphin
      kdePackages.elisa
      kdePackages.ffmpegthumbs
      kdePackages.gwenview
      kdePackages.kbookmarks
      kdePackages.kcmutils
      kdePackages.kcodecs
      kdePackages.kcolorscheme
      kdePackages.kcompletion
      kdePackages.kconfig
      kdePackages.kconfigwidgets
      kdePackages.kcoreaddons
      kdePackages.kcrash
      kdePackages.kdbusaddons
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kfilemetadata
      kdePackages.kguiaddons
      kdePackages.ki18n
      kdePackages.kiconthemes
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kjobwidgets
      kdePackages.knewstuff
      kdePackages.knotifications
      kdePackages.kparts
      kdePackages.kservice
      kdePackages.kservice
      kdePackages.ktextwidgets
      kdePackages.kuserfeedback
      kdePackages.kwidgetsaddons
      kdePackages.kwindowsystem
      kdePackages.kxmlgui
      kdePackages.okular
      kdePackages.phonon
      kdePackages.purpose
      kdePackages.qtbase
      kdePackages.qtimageformats
      kdePackages.qtstyleplugin-kvantum
      kdePackages.qtsvg
      kdePackages.qtwayland
      kdePackages.xdg-desktop-portal-kde
    ];
  };
}
