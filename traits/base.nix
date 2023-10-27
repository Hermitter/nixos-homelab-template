# Reminder: These configurations are automatically applied to each host
{ config, pkgs, lib, ... }:
{
  # Enable nix flakes
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  # Additional programs
  environment.systemPackages = with pkgs; [
    vim
    nano
    wget
    btop
  ];

  # Garbage Collection
  boot.loader.systemd-boot.configurationLimit = 25;
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 31d";
  };
}
