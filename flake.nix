{
  description = "I've seen your kind, time and time again. Every fleeting skill must be learnt. Every secret must be archived. Such is the burden of the self-proclaimed bearer of intellect.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Cry about it Blackmagic, I'm not paying for studio.
    nixpkgs-929116.url = "github:nixos/nixpkgs/929116e316068c7318c54eb4d827f7d9756d5e9c?shallow=1";

    # hyprland.url = "github:hyprwm/Hyprland?shallow=1";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-929116,
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
