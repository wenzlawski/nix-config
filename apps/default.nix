{self, ...} @ inputs:
self.lib.import.asApps' {
  path = ./.;
  appy = _: system: app:
    (app (inputs
      // {
        inherit system;
        inherit (self.lib.pkgs.${system}.${system}) pkgs;
        pkgs' = self.packages.${system}.${system};
      }))
    .overrideAttrs (super: {
      meta = (super.meta or {}) // self.lib.meta;
    });
}
