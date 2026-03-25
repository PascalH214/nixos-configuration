{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  networking.hostName = "vm";

  virtualisation.virtualbox.guest.enable = true;

  home-manager.extraSpecialArgs = {
    hyprMainMod = "ALT_R SHIFT_R";
  };
}
