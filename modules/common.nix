# Let knowledge serve only man, and let that which does not remain in darkness.
{
  inputs,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-929116,
  zenPkgs,
  lib,
  ...
}: {
  imports = [
    ./default.nix
    inputs.dankMaterialShell.nixosModules.dankMaterialShell
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Why didn't I set this sooner
  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;

  # Enable networking
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  i18n.inputMethod.fcitx5.waylandFrontend = true;
  
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-mellow-themes
      ];
    };
  };

  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = false;

  # Getting rid of plasma for now becuase holy hell it's messing up the rest of my system
  # services.desktopManager.plasma6.enable = true;

  # Enable fstrim, really should be enabled by default.
  services.fstrim.enable = true;

  # Why do gaming mice have such bad software
  services.ratbagd.enable = true;

  # AI bababooey.
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  systemd.user.extraConfig = "DefaultTimeoutStopSec=10s";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable bluetooth support
  hardware.bluetooth.enable = true;

  virtualisation.docker.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Define a user account. Don't forget to set a password with `passwd`.
  users.users.razushi = {
    isNormalUser = true;
    description = "Razushi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [];
  };

  # Explicit firmware packages (Can't be too sure...)
  boot.extraModulePackages = [pkgs.linux-firmware];

  # Redistributable firmware for AMD GPU and CPU
  hardware.enableRedistributableFirmware = true;

  # No idea how davinci worked before without this
  hardware.amdgpu.opencl.enable = true;

  # Ensure the AMDGPU driver is loaded
  services.xserver.videoDrivers = ["amdgpu"];

  # OpenGL and Vulkan Support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # DriSupport
    extraPackages = with pkgs; [
      mesa # 64-Bit
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      pkgs.pkgsi686Linux.mesa # 32-Bit
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Stuff only Scythe needs
    pkgs-929116.davinci-resolve
    blender
    krita
    pika-backup
    piper # Gaming peripherals GUI
    vlc
    pkgs-unstable.zed-editor

    # Luarocks
    strawberry
    obsidian # Siyuan failed...
    czkawka # Dupe file finder and cleaner

    sqlite # For a neovim plugin, I'm not joking.
    foxmarks
    usbutils

    borgbackup
    libnotify # For easy notifications within scripts.
    btrfs-progs

    brave
    firefox # Free from sandboxing from flatpak

    appimage-run # Tool for running appimages in NixOS
    clang # C compiler
    gcc # GNU Compiler Collection
    python3 # For scripts
    glib
    gnumake
    foot
    ghostty
    unzip # Used by some neovim stuff
    wl-clipboard # For terminal copy / paste # Switch to wl-clipboard-rs one day?
    xclip # Needed to copy to clipboard in terminal apps
    xdg-desktop-portal-gtk # Needed for cursor in some flatpak gtk apps
    gparted # Mhmmm...
    kitty # Hyprland defaults

    # From the moment I understood the weakness of the GUI...
    bat # cat but better.
    btop # Neat system monitor.
    dust # Dust, a rust written du replacement.
    duf # Disk usage utility, a better 'df'.
    eza # Rust based ls alternative.
    fastfetch # Neofetch but written in C and maintained.
    fd # Rust alternative to the find command.
    fzf # Great cl fuzzy finder in GO.
    git
    git-lfs
    helix
    imagemagick
    jq # Parse json in the cli.
    parallel # GNU parallel, thread your commands.
    ripdrag # Drag n drop, mainly for Yazi.
    ripgrep # Rust based recursive line search tool.
    smartmontools # Disk health monitoring stuff.
    starship # Terminal prompt written in Rust.
    tldr # Community made, minimal man pages.
    wget
    yt-dlp # Media downloader for many sites.
    zoxide # Rust alt to cd but smarter, integrates with yazi.

    # File management
    detox # Sanitizes filenames of special chars
    fdupes # Find dupe files
    _7zz-rar # This should just be a dependency smh.
    unar # The great archive tool.
    pkgs-unstable.yazi # The Rust TUI file manager.
    rclone # Multi-function remotes for mounts/backups.
    nautilus # Gotta have it for vscode by default... 
    xdg-desktop-portal-termfilechooser # Testing it out now...
    
    # Media Apps
    ffmpeg # The video converter
    inkscape
    mpv # The God of video / media players
    obs-studio
    zathura # The PDF viewer
    tesseract # OCR Engine
    foliate
    readest
    mediainfo

    # Misc software
    keepassxc
    vscode
    oniux
    openrgb-with-all-plugins

    # LSPs
    lua-language-server # Lua LSP
    markdown-oxide # A nice Markdown LSP
    nil # Nix lsp, RIP rnix dev
    harper # English grammar LSP
    basedpyright # Python typechecker LSP

    # formatters
    alejandra # Nix formatter

    # Gaming
    mangohud
    vkbasalt

    # Hm...
    inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.matugen.packages.${system}.default

    # Zen.... flake specialArgs
    zenPkgs.twilight

    # Bababooey magic! Beware!
    # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
    (let
      base = pkgs.appimageTools.defaultFhsEnvArgs;
    in
      pkgs.buildFHSEnv (base
        // {
          name = "fhs";
          targetPkgs = pkgs:
            (base.targetPkgs pkgs)
            ++ (
              with pkgs; [
                pkg-config
                ncurses
                # Feel free to add more packages here if needed.
              ]
            );
          profile = "export FHS=1";
          runScript = "bash";
          extraOutputsToInstall = ["dev"];
        }
      )
    )

  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.jetbrains-mono # Because Nerdfonts, for the waybar, should just be a default tbh so here it is
    nerd-fonts.victor-mono
    nerd-fonts.geist-mono

    fira-code
    atkinson-hyperlegible
    aileron
    geist-font

    maple-mono.NF-CN
  ];
  # Fixes emojis in Firefox, idk why
  fonts.fontconfig.useEmbeddedBitmaps = true;

  # Decent enough program
  programs.gnome-disks.enable = true;

  # Yup... phone
  programs.kdeconnect.enable = true;

  # Disabled because extension issues, somehow, grabbing it from just pkgs works better
  # programs.vscode.enable = true;

  # RGB control. 
  services.hardware.openrgb.enable = true;

  # Tool to run unpatched binaries, may or may not use
  #
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #
  # ];

  # Set shell to Fish
  programs.fish.enable = true;

  # Enable Flatpak globally
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Enable the firewall.
  networking.firewall.enable = true;
  networking.nameservers = [
    "1.1.1.2"
    "1.0.0.2"
    "2606:4700:4700::1112"
    "2606:4700:4700::1002"
  ];
  networking.networkmanager.dns = "none";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It?s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # Enables some "experimental" stuff, basically anything that's important but might change.
  # Enable the nix-command utility, a must have I'm told. Along with flakes, another prime pick.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some environment variables
  # Enable ozone for chromium apps, aka wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # # For file-picker portals for every compositor becuase idk why but I need to boot into hyprland first so that niri.
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-gnome
  #     pkgs.kdePackages.xdg-desktop-portal-kde
  #     inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
  #   ];
  #   config.common.default = ["gtk"];
  #   config.hyprland.default = ["hyprland" "gtk"];
  #   config.niri.default = ["gnome" "gtk"];
  #   config.plasma.default = ["kde" "gtk"];
  # };
}
