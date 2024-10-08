# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
# {pkgs ? (import ../nixpkgs.nix) {}}: {
pkgs: {
  borg-scripts = pkgs.callPackage ./borg {};
  xpo = pkgs.callPackage ./xpo {};
  testhello = pkgs.callPackage ./testhello.nix {};
  # emacs-30 = pkgs.callPackage ./emacs-30.nix {};
  # emacs-30withpkgs = (pkgs.emacsPackagesFor pkgs.emacs-30).emacsWithPackages (epkgs: [
  #   epkgs.jinx
  #   epkgs.vterm
  # ]);
}
