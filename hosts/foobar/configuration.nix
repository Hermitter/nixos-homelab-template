{ config, pkgs, host, hosts, globals, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Load a secret
  age.secrets."some_password.txt".file = host.path + /secrets/some_password.txt.age;

  # Examples to highlight (available under /etc/examples.txt)
  environment.etc."examples.txt".text = lib.mkForce ''
    Host Name: ${host.name}
    Host Path: ${host.path}
    A Host Variable: ${host.vars.hello}
    deploy-rs key: ${globals.sshKeys.deploy_rs}
    Secret Path (some_password.txt.age): ${config.age.secrets."some_password.txt".path}
  '';

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = host.name;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [ sl ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.05";
}
