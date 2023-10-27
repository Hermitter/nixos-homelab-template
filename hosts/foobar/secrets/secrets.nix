# Reminders: 
# - This file is only read while using the agenix CLI.
# - Changing any keys will require you to rekey.
# - Be careful to only reference a secret by it's path in your configuration, unless you want it exposed in the nix store.
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
