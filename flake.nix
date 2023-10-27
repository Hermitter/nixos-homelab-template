{
  description = "Server Deployments";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05"; # Update as needed
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";

  };
  outputs = { self, nixpkgs, nixpkgs-unstable, agenix, deploy-rs }@attrs:
    let
      # Generates a nix-shell environment for the following systems
      shell = {
        forAllSystems = f: nixpkgs.lib.genAttrs [
          "x86_64-linux" # 64-bit Intel/AMD Linux
          "aarch64-linux" # 64-bit ARM Linux (not tested)
          "x86_64-darwin" # 64-bit Intel macOS (not tested)
          "aarch64-darwin" # 64-bit ARM macOS (not tested)
        ]
          (system: f { pkgs = import nixpkgs { inherit system; }; });
      };

      # Generates the deployment configurations for each target machine
      deployments = (import ./functions/deploy.nix attrs) (import ./hosts);
    in

    {
      nixosModules = {
        traits = import ./traits;
        users = import ./users;
      };

      # Dependencies included in the nix-shell environment
      devShells = shell.forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = (with pkgs; [
            deploy-rs.packages.${system}.default
            agenix.packages.${system}.default
            nil
            nixpkgs-fmt
            just
          ]);
        };
      });

      # Deploy-rs
      nixosConfigurations = deployments.nixosConfigurations;
      deploy.nodes = deployments.nodes;
      ## reccomendation: This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
