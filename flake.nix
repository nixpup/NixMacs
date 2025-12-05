{
  description = "Reusable NixEmacs Configuration Module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # Export the module for home-manager
    homeManagerModules.default = import ./module.nix;
    
    # Convenience alias
    homeManagerModules.nixMacs = self.homeManagerModules.default;
  };
}