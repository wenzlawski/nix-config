# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs ? import <nixpkgs> {}, ...}: {
  # pkgs: {
  alerter = pkgs.callPackage ./alerter.nix {inherit pkgs;};
  borg-scripts = pkgs.callPackage ./borg-scripts {inherit pkgs;};
  testhello = pkgs.callPackage ./testhello.nix {};
  xpo = pkgs.callPackage ./xpo {};
  yabai-tile = pkgs.callPackage ./yabai-tile {};
}
