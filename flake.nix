{
  description = "iced_scythe system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  # @inputs passes all inputs through
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        # Capitalism baby
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        scythedNix = nixpkgs.lib.nixosSystem {
          # specialArgs = { inherit inputs system; }; # Do I need this?

          modules = [
            ./nixos/configuration.nix
            ./modules
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.scythe = import ./nixos/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              }; # Passes inputs to home-manager
            }
          ];
        };
      };
    };

}
