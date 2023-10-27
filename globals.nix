{
  sshKeys = {
    # REPLACE: with an ssh key from the machine deploying the configuration
    deploy_rs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChRj8vZKD7aXFQ9J1ldU+ESA8eT0aCbc6LuxNwH6Z8D some@user";
    # REPLACE: with the ssh key you're using to encrypt your secrets
    agenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEIqiwNwkbeJAD/Xvp0zlJdFBDVHFowOvrStdtyYeeDG some@user";
  };
}
