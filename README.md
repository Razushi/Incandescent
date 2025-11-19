# Incandescent - My Glorious Desktop.

> [!NOTE]
> Let knowledge serve only man, and let that which does not remain in darkness.

<details>
<summary>Environment details</summary>

### Setup:
- WM: Hyprland+Waybar / Niri+DMS / Plasma
- Shell: Fish
- Terminal: Ghostty
- Editor: Helix + Vscode
- Launcher: Vicinae
- Browser: Firefox / Brave

</details>

### Contents:
```
Incandescent/
├── hardware/        # Hardware-configuration.nix for my machines.
├── hosts/           # Hostname and module's import.
├── modules/         # ... modules.
│  ├── common.nix    # Imported, this is basically the normal configuration.nix
│  ├── <module>.nix  # You can read each individual module...
│  └── default.nix   # Tbh I don't like this but hey. 
└── flake.nix        # Flake inputs, we love flakes. 
```

Setup ocumentation located at: `Razushi/Anamnesis` & Dotfiles located at: `Razushi/Dotfiles`

# Rebuild:
> sudo nixos-rebuild $BUILD_OPTION --flake ~/Aeternitas/BRANCH/#HOSTNAME

Build option being either `Boot` (Reboot after to swap to new generation on a clean slate) or `Switch` to swap to new instance from current. 

### Showcase:
