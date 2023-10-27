# NixOS Homelab Template

A template for organizing multiple machines with secrets, shared configurations, and automatic rollback on erroneous deployments.

# Dependencies
> Aside from Nix with Flakes, everything else is for quality of life.
- [Nix with Flakes](https://zero-to-nix.com/start/install)
- [direnv](https://github.com/direnv/direnv)
- [VS Code](https://code.visualstudio.com/)

# Setup
For a deployment host&user example, you can view the `host/foobar` and `users/foobaz` folders.

## Secret Management [(agenix)](https://github.com/ryantm/agenix)
As a convention, secrets are added to a host's folder under the `secrets` folder. A `secrets.nix` should be there to declare your secrets and which SSH keys can decrypt them.

Below is an example of creating/decrypting a secret in `hosts/foobar/secrets`
```bash
cd hosts/foobar/secrets
# For deployments to decrypt foobar's secret, the SSH key should be the one set to agenix in `globals.nix`.
# If you run this command, be sure to remove the existing `some_password.txt.age` file as you'll have no way of reading it.
agenix -i <PATH_TO_PRIVATE_SSH_KEY> -e some_password.txt.age
```

## Deployments [(deploy-rs)](https://github.com/serokell/deploy-rs)
On a new or existing NixOS machine, ensure the following configurations are included (remember to include your SSH key).
```nix
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  
  # deploy-rs user
  users.users."deploy" = {
    description = "Server Deployment";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
        # REPLACE: with the deploy_rs key in globals.nix
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChRj8vZKD7aXFQ9J1ldU+ESA8eT0aCbc6LuxNwH6Z8D some@user"
    ];
  };

  nix.settings.trusted-users = [ "deploy" ];
  security.sudo.extraRules = [{
    users = [ "deploy" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
```

Register a new host in `hosts/default.nix` and a folder that shares the host's name. Inside that folder, add the `configuration.nix` and `hardware.nix` files for the machine you're deploying to.

Deploy your configuration!
```
# If direnv is not used
nix develop

just deploy <host_name>
```