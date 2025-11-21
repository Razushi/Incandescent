# Incandescent - My Glorious Desktop.

> [!NOTE]
> I do use flakes, but I do not use home-manager, this is mostly because build times are incredibly horrible with them enabled, also due partly to my method of dotfiles setup, as such; explicit nix theming is not really wanted and I value the ability to share configuration files (non-nixified) more than I do obsessing over the Nix language.
>
> This Nix configuration is located at: `Razushi/Incandescent` and my dotfiles exist at: `Razushi/Dotfiles`.
>
> Broader setup notes and scripts are located together in: `Razushi/Anamnesis`.
>
> The main goal of my configuration and the development path has mainly been to work with different hosts, which literally serve different purposes, with the ability to swap directly to use hyprland, niri, or plasma as my window manager to simply mess about with different environments. 
>
> In this regard, there really hasn't been that much development or adjustment from the base configuration.nix file. Feel free to freely abstract and take things out and adjust to your purposes, but I personally just don't feel the need to overly complicated unless needed. 

## Showcase:

<details>
<summary>Environment details</summary>

| Area     | Choice(s)                                 |
| -------- | ----------------------------------------- |
| WM   | Hyprland + Waybar / Niri + DMS / Plasma   |
| Shell    | Fish                                      |
| Terminal | Ghostty                                   |
| Editor   | Helix; VS Code                            |
| Launcher | Vicinae                                   |
| Browser  | Firefox; Brave                            |

To rebuild: `sudo nixos-rebuild $BUILD_OPTION --flake ~/Aeternitas/BRANCH/#HOSTNAME`

</details>

### Niri + DMS:
![Niri + DMS](./Showcase-Niri-Conf.png)

### Hyprland + Waybar:

![Hyprland + Waybar](./Showcase-Hyprland-Conf.png)

## Repo Structure:
```
Incandescent/
├── hardware/
├── hosts/
├── modules/
│  ├── common.nix
│  ├── <module>.nix
│  └── default.nix
└── flake.nix
```
```
common.nix/
├── Bootloader
├── Locale
├── Display Manager
├── User
├── Drivers
├── Environment System Packages
│  └── Magic
├── Fonts
└── System Settings
```

Cheers.
