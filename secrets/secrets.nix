let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZWQHzCPwdpFwanU6j5p+LPVPPH759mb3/4Ubl8qQ4u your_email@example.com";
  users = [user1];
  # system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
  # system2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzxQgondgEYcLpcPdJLrTdNgZ2gznOHCAxMdaceTUT1";
  # systems = [system1 system2];
in {
  "secret1.age".publicKeys = [user1];
  # age.secrets.secret1.file = ../secrets/secret1.age;
}
# let
#   personal_key = "ssh-rsa AAAA....";
#   remote_server_key = "ssh-rsa AAAA....";
#   keys = [personal_key remote_server_key];
# in {
#   "guest_accounts.json.age".publicKeys = keys;
#   "onlyoffice-jwt".path = /etc/nixos/onlyoffice-jwt;
# }

