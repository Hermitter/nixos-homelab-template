{ self, nixpkgs, nixpkgs-unstable, agenix, deploy-rs, ... }:

# Creates a nixosConfigurations.<hostName> and deploy.nodes.<hostName> for each host
nixpkgs.lib.attrsets.foldlAttrs
  (acc: hostName: host:
  let
    host_config = (../hosts + "/${hostName}/configuration.nix");
    host_vars = (../hosts + "/${hostName}/vars.nix");
  in
  {
    nixosConfigurations = acc.nixosConfigurations // (if !builtins.pathExists host_config then { } else {
      ${hostName} =
        let
          channels = {
            "nixpkgs-unstable" = nixpkgs-unstable;
            "nixpkgs" = nixpkgs;
          };

          # Selects the nix channel to build the host configuration with
          channel = nixpkgs.lib.attrByPath [ host.channel ]
            (builtins.abort "${host.channel} is not a valid channel.")
            channels;
        in
        channel.lib.nixosSystem
          {
            system = host.platform;
            # Additional imported arguments
            specialArgs =
              let
                # Host specific variables.
                attrs.host = {
                  # Note: these properties are reserved names in ../hosts/default.nix
                  # - name of host
                  name = hostName;
                  # - host specific variables
                  vars =
                    if builtins.pathExists host_vars then
                      (import host_vars)
                    else
                      (builtins.abort "${host_vars} does not exist");
                  # - path to host folder
                  path = ../hosts + "/${hostName}";
                  # - path to host secrets folder
                  # secrets = if builtins.pathExists (host_secrets + "/secrets.nix") then (host_secrets) else (builtins.abort "${(host_secrets + "/secrets.nix")} does not exist");
                } // host;
                # Variables shared between all hosts
                attrs.globals = import ../globals.nix;
                # Declarations for each host. (mainly for IP address)
                attrs.hosts = import ../hosts;
              in
              attrs;
            # Required modules
            modules = with self.nixosModules; [
              # Deployment user
              users.deploy
              # Grab the host's configuration
              (../hosts + ("/${hostName}/configuration.nix"))
              # Encrypted secrets
              agenix.nixosModules.default
            ] ++ host.modules;
          };
    });

    nodes = acc.nodes //
      (
        if !builtins.pathExists host_config then { } else
        {
          ${hostName} =
            let
              sshPort = if (host ? sshPort) then host.sshPort else 22;
            in
            {
              hostname = host.address;
              profiles.system = {
                sshUser = "deploy";
                sshOpts = [ "-p" (builtins.toString sshPort) ];
                user = "root";
                path = deploy-rs.lib.${host.platform}.activate.nixos self.nixosConfigurations.${hostName};
                remoteBuild = host.remoteBuild;
              };
            };
        }
      );
  })
{
  nixosConfigurations = { };
  nodes = { };
}
