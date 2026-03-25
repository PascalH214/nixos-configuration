{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.pascal = { pkgs, ... }: {
    programs = {
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

    wayland.windowManager.hyprland = {
      enable = true;
    };

    home.stateVersion = "25.11";
  };
}

