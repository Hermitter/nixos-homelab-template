# Update flake.lock
update:
    nix flake update --verbose

# Deploy a homelab machine's config
deploy MACHINE:
    deploy '.#{{MACHINE}}'

# Calls the Nix formatter
fmt *args:
    @nixpkgs-fmt  {{args}}
