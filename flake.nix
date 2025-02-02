{
  description = "I've seen your kind, time and time again. Every fleeting skill must be learnt. Every secret must be archived. Such is the burden of the self-proclaimed bearer of intellect.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Cry about it Blackmagic, I'm not paying for studio.
    nixpkgs-929116.url = "github:nixos/nixpkgs/929116e316068c7318c54eb4d827f7d9756d5e9c";
  };

  # @inputs passes all inputs through
  outputs = {
    self,
    nixpkgs,
    nixpkgs-929116,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      # Capitalism baby
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      CinderedNix = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs-929116 = import nixpkgs-929116 {
            inherit system;
            config.allowUnfree = true;
          };
        };

        modules = [
          ./nixos/configuration.nix
          ./modules
        ];
      };
    };
  };
}
