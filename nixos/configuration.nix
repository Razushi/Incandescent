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

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Why didn't I set this sooner
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  networking.hostName = "stasisos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Wtf is turning this on???
  services.xserver.displayManager.lightdm.enable = false;

  # Enable fstrim, really should be enabled by default.
  services.fstrim.enable = true;

  # Why do gaming mice have such bad software.
  services.ratbagd.enable = true;

  # AI bababooey.
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # Enables my nix-ld config with a bunch of pkgs.
  scythesNixld.enable = true;
  # Enable configs for desktop RTX3060.
  desktop3060.enable = true;
  # Enable Hyprland miscellanea.
  hyprmisc.enable = true;
  # Tons of KDE bloat, tons.
  kdeStuff.enable = true;

  # Configure keymap in X11.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable Kanata, keyboard remap program.
  services.kanata = {
    enable = true;
    keyboards.main.extraDefCfg = "process-unmapped-keys yes";
    keyboards.main.config = ''
      (defsrc
        caps
        lmeta lalt
      )

      (defalias
        caps2esc (tap-hold 200 200 esc caps)
      )

      (deflayer main
        @caps2esc
        lalt lmeta
      )
    '';
    keyboards.main.devices = [
      "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd"
    ];
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

  # Enable bluetooth support.
  hardware.bluetooth.enable = true;

  # Steering wheel
  hardware.new-lg4ff.enable = true;
  services.udev.packages = with pkgs; [oversteer];

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_25;
    daemon.settings = {data-root = "/storage_hdds/wb_1tb_hdd/docker";};
  };

  # NOTE Enables docker bababooey, not needed unless planning to use Nvidia in docker
  hardware.nvidia-container-toolkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.scythe = {
    isNormalUser = true;
    description = "Scythe";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [];
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Stuff only Scythe needs
    # pkgs-929116.davinci-resolve
    davinci-resolve
    blender
    kdePackages.kdenlive
    pika-backup
    piper # Gaming peripherals GUI.
    vlc
    oversteer # Wheel / pedal manager.
    # Actually needed for luarocks, might make a module or something.
    lua51Packages.lua
    lua51Packages.luarocks
    luajitPackages.magick
    strawberry
    obsidian
    czkawka # Dupe file finder and cleaner

    # Bababooey magic! Beware!
    # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
    (let
      base = pkgs.appimageTools.defaultFhsEnvArgs;
    in
      pkgs.buildFHSEnv (base
        // {
          name = "fhs";
          targetPkgs = pkgs:
          # pkgs.buildFHSUserEnv provides only a minimal FHS environment,
          # lacking many basic packages needed by most software.
          # Therefore, we need to add them manually.
          #
          # pkgs.appimageTools provides basic packages required by most software.
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
        }))

    sqlite # For a neovim plugin, I'm not joking.
    nodePackages.nodejs
    android-tools
    hexyl
    foxmarks
    usbutils

    borgbackup
    libnotify # For easy notifications within scripts.
    btrfs-progs

    appimage-run # Tool for running appimages in NixOS.
    clang # C compiler.
    gcc # GNU Compiler Collection.
    python3 # For scripts.
    glib
    gnumake
    kitty # They put so much money into it, unfortunately made it better.
    foot # What's one more terminal?
    ghostty
    unzip # Used by some neovim stuff.
    wl-clipboard # For terminal copy / paste # Switch to wl-clipboard-rs one day?.
    xclip # Needed to copy to clipboard in terminal apps.
    xdg-desktop-portal-gtk # Needed for cursor in some flatpak gtk apps.

    # From the moment I understood the weakness of the GUI...
    bat # cat but better.
    btop # Neat system monitor.
    du-dust # Dust, a rust written du replacement.
    duf # Disk usage utility, a better 'df'.
    eza # Rust based ls alternative.
    fastfetch # Neofetch but written in C and maintained.
    fd # Rust alternative to the find command.
    fzf # Great cl fuzzy finder in GO.
    git
    glow # Command line Markdown viewer.
    helix
    imagemagick
    jq # Parse json in the cli.
    neovim # The new classic.
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
    detox # Sanitizes filenames of special chars.
    fdupes # Find dupe files.
    _7zz-rar # This should just be a dependency smh.
    unar # The great archive tool.
    yazi # The Rust TUI file manager.
    sshfs # For remote filesystems, mounts over SSH.

    # Media Apps ---
    # obs-studio # Doesn't fkin work for some reason.
    brave
    ffmpeg # The video converter.
    firefox
    inkscape
    mpv # The God of video / media players.
    pandoc # Ultimate Document converter.
    tesseract
    texliveFull # Needed by pandoc & others to convert to PDF.
    thunderbird
    koreader
    readest
    zathura # The PDF viewer.
    mediainfo

    # Misc software ---
    jetbrains.idea-community-bin # The Java IDE.
    keepassxc
    # libreoffice # The FOSS office suite.
    temurin-bin-17 # 2024 and we still can't include these things in-app.
    vscodium
    oniux # You fool, I have 70 alternative accounts!

    # LSPs ---
    lua-language-server # Lua LSP.
    markdown-oxide # A nice Markdown LSP.
    nil # Nix lsp, RIP rnix dev.
    harper # English grammar LSP.
    basedpyright # Python typechecker LSP.

    # formatters ---
    alejandra # Nix formatter.
    nodePackages.prettier # Formatter for a lot of things, including markdown.
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];
  # Fixes emojis in Firefox, idk why
  fonts.fontconfig.useEmbeddedBitmaps = true;

  programs.gnome-disks.enable = true;

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
    "9.9.9.9"
    "2620:fe::fe"
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
