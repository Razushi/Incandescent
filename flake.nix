{ 
  description = "I've seen your kind, time and time again. Every fleeting skill must be learnt. Every secret must be archived. Such is the burden of the self-proclaimed bearer of intellect.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";
    nixpkgs-unstable.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland?ref=v0.55.4&shallow=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?ref=v0.55.0&shallow=1";
      inputs.hyprland.follows = "hyprland";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qtengine = {
      url = "github:kossLAN/qtengine";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    hyprland,
    dms,
    qtengine,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    inherit (nixpkgs.lib) nixosSystem;

    specialArgs = {
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {allowUnfree = true;};
      };
      
      zenPkgs = inputs.zen-browser.packages.${system};

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
