# Incandescent - My Glorious Desktop.
This is my (poor man's) Linux Workstation, 7900X3D + 7800 XT + 64GB RAM. Runs NixOS with Hyprland. 
This is essentially my homelabs and my research station. 

> [!NOTE]
> Syncing to Razushi/Aeternitas:
> ```
> rsync -av --exclude='.git' --exclude='Documentation' ~/Aeternitas/Solaris/ ~/Fuli/
> ``` 
> Additionally: to verify which files will be copied (and excluded): `--dry-run` 

 
Addendum: Main host. 

Chore: see siyuan intergration with WSL + flatpak, maybe I could just deadass use it there, that way I can just rysnc it to git and go on from there?

In order to sync

> sudo nixos-rebuild $BUILD_OPTION --flake ~/Aeternitas/Incandescent/#CinderedNix

Build option being either `Boot` (Reboot after to swap to new generation on a clean slate) or `Switch` to swap to new instance from current. 
