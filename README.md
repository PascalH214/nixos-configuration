# NixOS-Configuration

Ignore this repository. I'm new to Nix/NixOS and am now trying to learn it.

## Structure

- `hosts/pc`: PC-specific NixOS configuration
- `hosts/vm`: VM-specific NixOS configuration
- `modules/nixos`: shared NixOS modules used by all hosts
- `dotfiles/` and `hypr-scripts/`: user environment assets

## Setup

```console
sudo mv /etc/nixos /etc/nixos.backup
sudo ln -s ~/nixos-configuration /etc/nixos
sudo nixos-rebuild switch -I nixos-config=./hosts/pc/default.nix
```

## Rebuild Per Host

```console
# PC
sudo nixos-rebuild switch -I nixos-config=./hosts/pc/default.nix

# VM
sudo nixos-rebuild switch -I nixos-config=./hosts/vm/default.nix
```
