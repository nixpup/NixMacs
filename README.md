# NixMacs

A NixOS Flake Module to use my custom configuration of Emacs (NixMacs) easily as a Module inside your Flake.

# Requirements
 - Be at least on **NixOS** Version **25.05** (Warbler)
 - Have **home-manager** Installed

# Try NixMacs
## Without Installing on NixOS
Simply run `nix run github:nixpup/NixMacs#nixmacs` (you may need to add the `--no-write-lock-file` flag) inside a Terminal and you can test NixMacs without having to install or configure anything!

# Installation
## Inside a Flake
**flake.nix**:
```nix
{
  # ... your configuration.
  nixmacs = {
    url = "github:nixpup/NixMacs";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  outputs = { self, nixpkgs, home-manager, nixmacs, ... }:
  let
    system = "x86_64-linux";
  in
    nixosConfiguration.YOUR_HOSTNAME = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # ...your modules.
        home-manager.nixosModules.home-manager

        ({ config, pkgs, lib, ... }: 
          imports = [
            home-manager.nixosModules.home-manager
          ];
          home-manager = {
            # ...your home-manager configuration.
            sharedModules = [
              nixmacs.homeManagerModules.default
            ];
          };
        )
      ];
    };
}
```

**home.nix**:
```nix
{ config, pkgs, lib, ... }:
# ...your home configuration.
nixMacs = {
  enable = true;
  exwm = {
    enable = true; # Create "~/.exwm.el" File.
    layout = "qwerty"; # Can also be "colemak".
  };
  waylandPackage.enable = true; # Enable the creation of a "nixmacs-wayland" binary.
};
```

# Showcase
![Showcase](https://raw.githubusercontent.com/nixpup/NixMacs/refs/heads/main/example.png)
