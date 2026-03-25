{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.extraSpecialArgs = {
    hyprMainMod = lib.mkDefault "SUPER";
  };

  home-manager.users.pascal = { pkgs, ... }: {
    imports = [
      ../../hyprland.nix
    ];

    xdg.configFile = {
      "btop/btop.conf".source = ../../home/dot_config/btop/btop.conf;
      "btop/themes/catppuccin_mocha.theme".source = ../../home/dot_config/btop/themes/catppuccin_mocha.theme;
    };

    programs = {
      btop.enable = true;
      bash.enable = true;
      kitty.enable = true;
      git = {
        enable = true;
	settings = {
	  user = {
	    email = "pascal02012004@freenet.de";
	    username = "PascalH214";
	  };
	};
      };
    };

    home.stateVersion = "25.11";
  };
}

