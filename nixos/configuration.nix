# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Why didn't I set this sooner
  # boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true; # Do we need this now or something?
  services.desktopManager.plasma6.enable = true;

  # Enable fstrim, really should be enabled by default.
  services.fstrim.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable bluetooth support
  hardware.bluetooth.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.scythe = {
    isNormalUser = true;
    description = "Scythe";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
     ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run # Tool for running appimages in NixOS
    btop # Neat system monitor
    clang # C compiler
    detox # Sanitizes filenames of special chars
    du-dust # Dust, a rust written du replacement
    eza # Rust based ls alternative
    fd # Rust alternative to the find command
    firefox
    fzf # Great cl fuzzy finder in GO
    gcc # GNU Compiler Collection
    git
    gnome.gnome-disk-utility # Great disk utility
    imv # Minimal Wayland image viewer
    mpv # The God of video / media players
    neovim # The new classic.
    ripgrep # Rust based recursive line search tool
    smartmontools # Disk health monitoring stuff
    starship # Terminal prompt written in Rust
    tldr # Community made, minimal man pages
    unar # The great archive tool
    vim # The classic.
    wget
    wl-clipboard # For terminal copy / paste # Switch to wl-clipboard-rs one day?
    xclip # Needed to copy to clipboard in terminal apps
    yazi # The Rust TUI file manager
    zoxide # Rust alt to cd but smarter, integrates with yazi

    # Just for hyprland
    xdg-desktop-portal-hyprland # XDG portal for hyprland
    xdg-desktop-portal-gtk # Another XDG portal for hyprland
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Because Plasma 6 broke Dolphin
  programs.thunar.enable = true;

  # Gnome made us need this
  programs.dconf.enable = true;

  # Window manager
  # programs.hyprland.enable = true;

  # Thanks Gaben
  programs.gamemode.enable = true;

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
  
  # Enable GVfs for file managers like Thunar and other tools
  services.gvfs.enable = true;
  
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

  # if you really want to have it set. Otherwise ignore it, hell if I know what the thing even does.
  system.stateVersion = "23.05"; # Did you read the comment?

  # Enables some "experimental" stuff, basically anything that's important but might change.
  # Enable the nix-command utility, a must have I'm told. Along with flakes, another prime pick.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Some environment variables
  # Enable ozone for chromium apps, aka wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";


  ################
  # NVIDIA STUFF #
  ################

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;

  #---------------Nvidia End---------------#
  
  };

}
