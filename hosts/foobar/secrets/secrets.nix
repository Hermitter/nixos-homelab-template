# Reminders: 
# - This file is only read while using the agenix CLI.
# - Changing any keys will require you to re-encry.
# - Secrets should only be referenced by paths and not value in your configurations, unless you want it exposed in the nix store.
let
  hosts = import ../../default.nix;
  globals = import ../../../globals.nix;
  keys = [
    hosts.foobar.pubkey
    globals.sshKeys.agenix
  ];
in
{
  "some_password.txt.age".publicKeys = keys;
}
