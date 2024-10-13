# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{pkgs ? (import ../nixpkgs.nix) {}}: {
  # pkgs: {
  borg-scripts = pkgs.callPackage ./borg {};
  xpo = pkgs.callPackage ./xpo {};
  testhello = pkgs.callPackage ./testhello.nix {};
}
