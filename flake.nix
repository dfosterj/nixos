{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    # stylix.url  = "github:danth/stylix/cf8b6e2d4e8aca8ef14b839a906ab5eb98b08561";

    home-manager = {
    url = "github:nix-community/home-manager/release-24.11";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        /etc/nixos/configuration.nix
        inputs.home-manager.nixosModules.default
        # stylix.nixosModules.stylix
      ];
    };
  };
}
