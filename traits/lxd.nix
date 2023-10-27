{ config, pkgs, lib, ... }:
{
  config = {
    virtualisation.lxd = {
      enable = true;

      recommendedSysctlSettings = true;
    };
  };
}
