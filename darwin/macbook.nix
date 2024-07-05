{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) nixpkgs;
in {
  imports = [
    ./common.nix
    ./features/yabai.nix
    ./features/yabai-scripting-additions.nix
    ./features/brew.nix
    ./features/agents.nix
    ./features/librewolf.nix
  ];

  home-manager.users.mw = import ../home-manager/mw/hosts/macbook-darwin.nix;

  system.stateVersion = 4;
}
