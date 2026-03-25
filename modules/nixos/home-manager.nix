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

    programs = {
      bash.enable = true;
      kitty.enable = true;
      vscode = {
        enable = true;
        package = pkgs.vscodium;
            };
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

