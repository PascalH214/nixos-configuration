{ config, pkgs, ... }:

{
  users = {
    users = {
      pascal = {
        isNormalUser = true;
        description = "pascal";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [];
      };
    };
  };
}

