{ config, pkgs, inputs, ... }:

{
  home.username = "scythe";
  home.homeDirectory = "/home/scythe";

  imports = [];

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';
  
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    # From the moment I understood the weakness of the GUI..
    glow # Command line Markdown viewer
    imagemagick
    lutgen # LUT utility for wallpapers and stuff
    fastfetch # Neofetch but written in C and maintained
    pandoc # Ultimate Document converter
    python3 # They put so much money into it, unfortunately made it better
    # steam-run # To run Davinci atm, curtesy of Mr Newell
    yt-dlp # Media downloader for many sites
    
    # Media Apps
    davinci-resolve # The video editor
    inkscape
    obs-studio
    tauon # Music player
    zathura # The PDF viewer

    # Misc apps
    keepassxc
    kitty # They put so much money into it, unfortunately made it better
    libreoffice # The FOSS office suite
    vscodium

    # Misc software
    ffmpeg_6-full # The video converter 
    jetbrains.idea-community # The Java IDE
    lua-language-server # Lua LSP
    marksman # A nice Markdown LSP
    nil # Nix lsp, RIP rnix dev
    temurin-bin-17 # 2024 and we still can't include these things in-app
    texlive.combined.scheme-full # Needed by pandoc & others to convert to PDF

  ];


  # The bababooey number
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
