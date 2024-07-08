{
  config,
  pkgs,
  ...
}: let
in {
  imports = [
    ./librewolf.nix
  ];
}
