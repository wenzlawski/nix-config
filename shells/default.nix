{self, ...} @ inputs:
self.lib.import.asShells' {
  path = ./.;
  apply = _: system: shell:
    shell (inputs
      // {
        inherit system;
        inherit (self.lib.pkgs.${system}.${system}) pkgs;
        pkgs' = self.packages.${system}.${system};
      });
}
