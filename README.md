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

In order to sync

> sudo nixos-rebuild $BUILD_OPTION --flake ~/Aeternitas/Incandescent/#CinderedNix

Build option being either `Boot` (Reboot after to swap to new generation on a clean slate) or `Switch` to swap to new instance from current. 

# Branch Differences:
main: Is basically my current testing copies, changes will have proper commit notes from now on:
iced_scythe: Scythe's version. 

Use:
- `git branch -b iced_scythe` # Creates the branch
- `git branch` # Shows all branches
- `git checkout #branchname` # Swaps to the respective branch
- `git push -u origin #branchname` # the -u flag links Local to Remote`
- `git push origin #branchname` # I will probably still use this simply becuase of habit. Will hopefully change this when I start using Jujutsu (git replacement)
