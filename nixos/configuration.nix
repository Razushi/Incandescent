# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  pkgs-929116,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Why didn't I set this sooner
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  networking.hostName = "IncandescentOS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Enable fstrim, really should be enabled by default.
  services.fstrim.enable = true;

  # Why do gaming mice have such bad software
  services.ratbagd.enable = true;

  # Enables my nix-ld config with a bunch of pkgs
  scythesNixld.enable = true;

  # Enable Hyprland miscellanea
  hyprmisc.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  virtualisation.docker.package = pkgs.docker_25;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # OpenGL and Vulkan Support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # DriSupport
    extraPackages = with pkgs; [
      pkgs.mesa.drivers # 64-Bit
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
    kdePackages.kdenlive
    pika-backup
    piper # Gaming peripherals GUI
    vlc

    # firefox
    appimage-run # Tool for running appimages in NixOS
    clang # C compiler
    gcc # GNU Compiler Collection
    python3 # For scripts
    glib
    gnumake
    kitty # They put so much money into it, unfortunately made it better
    ghostty
    unzip # Used by some neovim stuff
    wl-clipboard # For terminal copy / paste # Switch to wl-clipboard-rs one day?
    xclip # Needed to copy to clipboard in terminal apps
    xdg-desktop-portal-gtk # Needed for cursor in some flatpak gtk apps
    gparted

    # From the moment I understood the weakness of the GUI...
    bat # cat but better
    btop # Neat system monitor
    du-dust # Dust, a rust written du replacement
    duf # Disk usage utility, a better 'df'
    eza # Rust based ls alternative
    fastfetch # Neofetch but written in C and maintained
    fd # Rust alternative to the find command
    fzf # Great cl fuzzy finder in GO
    git
    glow # Command line Markdown viewer
    helix
    imagemagick
    jq # Parse json in the cli
    neovim # The new classic.
    ripdrag # Drag n drop, mainly for Yazi
    ripgrep # Rust based recursive line search tool
    smartmontools # Disk health monitoring stuff
    starship # Terminal prompt written in Rust
    tldr # Community made, minimal man pages
    wget
    yt-dlp # Media downloader for many sites
    zoxide # Rust alt to cd but smarter, integrates with yazi

    # File management
    detox # Sanitizes filenames of special chars
    fdupes # Find dupe files
    p7zip-rar # This should just be a dependency smh
    unar # The great archive tool
    yazi # The Rust TUI file manager
    siyuan # My pkm of choice... mainly becuase I don't want to set up Neorg + ObsidianNo thanks.

    # Media Apps
    ffmpeg # The video converter
    inkscape
    mpv # The God of video / media players
    obs-studio
    pandoc # Ultimate Document converter
    # tauon # Music player
    texliveFull # Needed by pandoc & others to convert to PDF
    zathura # The PDF viewer

    # Misc software
    jetbrains.idea-community-bin # The Java IDE
    keepassxc
    libreoffice # The FOSS office suite
    lua-language-server # Lua LSP
    markdown-oxide # A nice Markdown LSP
    nil # Nix lsp, RIP rnix dev
    alejandra # Nix formatter
    harper # English grammar LSP
    basedpyright # Python typechecker LSP
    temurin-bin-17 # 2024 and we still can't include these things in-app
    vscodium

    # Gaming
    vulkan-tools # 64-Bit vulkaninfo
    pkgs.pkgsi686Linux.vulkan-tools # 32-bit vulkaninfo
    mesa-demos # Testing stuff, glxinfo
    gamemode
    libstrangle
    mangohud
    vkBasalt

    android-tools
    universal-android-debloater
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    fira-code
    atkinson-hyperlegible
    aileron
    geist-font
  ];

  programs.gnome-disks.enable = true;

  # Tool to run unpatched binaries, may or may not use
  #
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #
  # ];

  # Set shell to Fish
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # List services that you want to enable:

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
    "1.1.1.1"
    "2606:4700:4700::1111"
  ];
  networking.networkmanager.dns = "none";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
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
}
