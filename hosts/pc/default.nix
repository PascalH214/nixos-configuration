{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  networking.hostName = "pc";

  home-manager.extraSpecialArgs = {
    hyprMainMod = "SUPER";
  };
}
