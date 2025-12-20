{ lib, pkgs, pkgs-unstable, inputs, config, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPortal = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  quickshellPkg = pkgs-unstable.stdenv.mkDerivation {
    pname = "quickshell-git";
    version = "git-26531fc";
    src = pkgs.fetchgit {
      url = "https://git.outfoxxed.me/quickshell/quickshell";
      rev = "26531fc46ef17e9365b03770edd3fb9206fcb460";
      sha256 = "sha256-sHqLmm0wAt3PC4vczJeBozI1/f4rv9yp3IjkClHDXDs=";
    };

    nativeBuildInputs = with pkgs-unstable; [
      cmake
      ninja
      pkg-config
      qt6.wrapQtAppsHook
      qt6.qttools
      qt6.qtwayland
      wayland-scanner
    ];

    buildInputs = with pkgs-unstable; [
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtwayland
      qt6.qtsvg
      qt6.qt5compat
      qt6.qtshadertools
      qt6.qtpositioning
      qt6.qtmultimedia
      qt6.qtimageformats
      qt6.qtquicktimeline
      qt6.qtsensors
      qt6.qtvirtualkeyboard
      kdePackages.kirigami
      kdePackages.syntax-highlighting
      pam
      cli11
      glib
      pipewire
      libdrm
      libxcb
      wayland
      wayland-protocols
      mesa
      polkit
      sysprof
      jemalloc
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCRASH_REPORTER=OFF"
      "-DUSE_JEMALLOC=ON"
      "-DWAYLAND=ON"
      "-DSERVICE_PIPEWIRE=ON"
      "-DSERVICE_POLKIT=ON"
      "-DHYPRLAND=ON"
      "-DI3=OFF"
      "-DSERVICE_PAM=ON"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DQML_INSTALL_DIR=lib/qt-6/qml"
    ];

    qtWrapperArgs = [
      "--set-default" "QML2_IMPORT_PATH"
      "${placeholder "out"}/lib/qt-6/qml:${pkgs-unstable.qt6.qtdeclarative}/lib/qt-6/qml"
    ];
  };
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
      # Force a single hyprland portal provider to avoid duplicate user units.
      extraPortals = lib.mkForce [
        hyprlandPortal
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
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
      ++ [
        quickshellPkg
        pkgs.kdePackages.plasma-nm
        pkgs.papirus-icon-theme
        pkgs.kdePackages.breeze-icons
      ]
      ++ (with pkgs-unstable;
        lib.optionals (pkgs-unstable ? hyprshot) [pkgs-unstable.hyprshot]
        ++ lib.optionals (pkgs-unstable ? uv) [pkgs-unstable.uv])
    );

    programs.dankMaterialShell.quickshell = lib.mkForce { package = quickshellPkg; };

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
