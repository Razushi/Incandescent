Command to build:
sudo nixos-rebuild switch --flake ~/iced_scythe/#scythedNix
sudo nixos-rebuild boot --flake ~/iced_scythe/#scythedNix

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub app.drey.Warp -y
flatpak install flathub com.calibre_ebook.calibre -y
flatpak install flathub com.github.taiko2k.tauonmb -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub com.usebottles.bottles -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub dev.vencord.Vesktop -y
flatpak install flathub im.riot.Riot -y
flatpak install flathub org.DolphinEmu.dolphin-emu -y
flatpak install flathub org.b3log.siyuan -y
flatpak install flathub org.mozilla.Thunderbird -y
flatpak install flathub org.mozilla.firefox -y
flatpak install flathub org.prismlauncher.PrismLauncher -y
