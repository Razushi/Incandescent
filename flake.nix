{ 
  description = "I've seen your kind, time and time again. Every fleeting skill must be learnt. Every secret must be archived. Such is the burden of the self-proclaimed bearer of intellect.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05?shallow=1";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";

    # Cry about it Blackmagic, I'm not paying for studio.
    nixpkgs-929116.url = "github:nixos/nixpkgs/929116e316068c7318c54eb4d827f7d9756d5e9c?shallow=1";

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Great launcher, sadly react slop.
    vicinae = {
      url = "github:vicinaehq/vicinae?ref=v0.16.0&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland?ref=v0.51.1&shallow=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?rev=81f6d1426537981fcbb921f8b5e470b1280ef8f3&shallow=1";
      inputs.hyprland.follows = "hyprland";
    };

    matugen = {
      url = "github:InioX/matugen?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-929116,
    dankMaterialShell,
    vicinae,
    matugen,
    hyprland,
    hyprland-plugins,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    inherit (nixpkgs.lib) nixosSystem;

    specialArgs = {
      pkgs-929116 = import nixpkgs-929116 {
        inherit system;
        config = {allowUnfree = true;};
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {allowUnfree = true;};
      };
      inherit inputs;
    };

    mkHost = hostModule:
      nixosSystem {
        inherit system specialArgs;
        modules = [hostModule];
      };
  in {
    nixosConfigurations = {
      incandescent = mkHost ./hosts/incandescent.nix;
      solaris = mkHost ./hosts/solaris.nix;
    };
  };
}
