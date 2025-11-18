{
  description = "I've seen your kind, time and time again. Every fleeting skill must be learnt. Every secret must be archived. Such is the burden of the self-proclaimed bearer of intellect.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Cry about it Blackmagic, I'm not paying for studio.
    nixpkgs-929116.url = "github:nixos/nixpkgs/929116e316068c7318c54eb4d827f7d9756d5e9c?shallow=1";

    # DMS, even yalter uses it now...
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-cli = {
      url = "github:AvengeMedia/danklinux?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant.url = "github:abenz1267/elephant?shallow=1";
    walker = {
      url = "github:abenz1267/walker?shallow=1";
      inputs.elephant.follows = "elephant";
    };

    # Great launcher, sadly react slop.
    vicinae = {
      url = "github:vicinaehq/vicinae?ref=v0.16.2&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The great archives must be organized.
    # tagstudio = {
    #   url = "github:TagStudioDev/TagStudio?shallow=1";
    #   inputs.nixpkgs.follows = "nixpkgs"; # Use the same package set as your flake.
    # };

    hyprland.url = "github:hyprwm/Hyprland?ref=v0.51.1&shallow=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins?shallow=1";
      inputs.hyprland.follows = "hyprland";
    };

    matugen = {
      url = "github:InioX/matugen?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # @inputs passes all inputs through
  outputs = {
    self,
    nixpkgs,
    nixpkgs-929116,
    dms-cli,
    dank-material-shell,
    vicinae,
    hyprland,
    walker,
    matugen,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    inherit (nixpkgs.lib) nixosSystem;

    specialArgs = {
      pkgs-929116 = import nixpkgs-929116 {
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

