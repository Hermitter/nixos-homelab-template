# Update flake.lock
update:
    nix flake update --verbose

# Deploy a homelab machine's config
deploy MACHINE:
    deploy '.#{{MACHINE}}'

# Passes the path to nixpkgs-fmt
fmt *args:
    @nixpkgs-fmt  {{args}}
