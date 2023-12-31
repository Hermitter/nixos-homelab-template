let
  users = import ../users;
  traits = import ../traits;
in
# RESERVED VARIABLES:
  # <host>.name -> host's name
  # <host>.path -> path to host's folder
  # <host>.vars -> vars.nix file in host's folder
{
  # Host names are used to find "hosts/<host>/configuration.nix"
  foobar = {
    # REPLACE with target machine's IP address
    address = "192.168.122.5";
    # Use the stable channel.
    channel = "nixpkgs"; # "nixpkgs-unstable" is also available
    # REPLACE with target machine's architecture
    platform = "x86_64-linux";
    # REPLACE with public ssh key from target machine's /etc/ssh folder
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIokUQI3L+GCtrWZGUbQTu6UTEY2odFcH0tH97Xdvr/N root@nixos";
    # Build the configuration derivation on target machine. 
    remoteBuild = true;
    # Specify SSH Port (already default to 22)
    # sshPort = 22;
    # NixOS modules to include in target machine configuration
    modules = [
      # REPLACE with the modules you want
      traits.base
      traits.lxd
      users.foobaz

      # The following modules are required and already imported by default:
      ## The user deploy-rs uses to deploy the configuration 
      ## - users.deploy
    ];
  };
}
