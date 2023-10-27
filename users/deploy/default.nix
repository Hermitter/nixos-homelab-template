{ config, pkgs, lib, globals, ... }:
let
  username = "deploy";
in
{
  users.users."${username}" = {
    description = "Server Deployment";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      globals.sshKeys.deploy_rs
    ];
  };

  nix.settings.trusted-users = [ username ];
  security.sudo.extraRules = [{
    users = [ username ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
}
