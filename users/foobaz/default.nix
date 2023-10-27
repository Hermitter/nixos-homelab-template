{ lib, pkgs, globals, ... }:
{

  # (Don't forget to set a password with ‘passwd <username>’)
  users.users.foobaz = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      trash-cli
      sl
    ];
  };
}
