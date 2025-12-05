{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixMacs;
in {
  options.nixMacs = {
    enable = mkEnableOption "custom Emacs configuration";
    
    home = mkOption {
      type = types.str;
      default = config.home.homeDirectory or "/home/${config.home.username or "user"}";
      description = "Home directory path";
    };
    
    package = mkOption {
      type = types.package;
      default = pkgs.emacs29;
      description = "Emacs package to use";
    };
    
    extraPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = epkgs: with epkgs; [];
      description = "Extra Emacs packages to install";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.emacsWithPackages (epkgs: with epkgs; [
        # Your default packages here
        use-package
        color-theme-sanityinc-tomorrow
        company
        emms
        fancy-dabbrev
        lsp-mode
        lsp-ui
        markdown-mode
        multi-term
        multiple-cursors
        nix-buffer
        nix-mode
        rainbow-mode
        rust-mode
        rustic
        wttrin
        hydra
        all-the-icons
        haskell-mode
        arduino-mode
        flycheck
        gruvbox-theme
        bongo
        org  # Important: make sure org is included!
        # ... add more packages
      ] ++ (cfg.extraPackages epkgs)))
    ];

    # Create the .emacs bootstrap file
    home.file.".emacs" = {
      text = ''
        (let ((orgfile "~/.e.org")
              (elfile "~/.e.el"))
          (when (or (not (file-exists-p elfile))
	            (file-newer-than-file-p orgfile elfile))
            (require 'org)
            (org-babel-tangle-file orgfile elfile))
          (load-file elfile))
      '';
    };
    
    # Symlink your org-mode configuration
    home.file.".e.org" = {
      source = ./config/e.org;
    };
  };
}