{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.zig.url = "github:mitchellh/zig-overlay";

  outputs = inputs @ {self, ...}:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      nativeBuildInputs = with pkgs; [
        inputs.zig.packages.${system}.master
        zls
      ];

      buildInputs = with pkgs; [];
    in {
      devShells.default = pkgs.mkShell {inherit nativeBuildInputs buildInputs;};

      packages.default = pkgs.stdenv.mkDerivation {
        pname = "template";
        version = "0.0.0";
        src = ./.;

        nativeBuildInputs =
          nativeBuildInputs
          ++ [
            pkgs.zig.hook
          ];
        inherit buildInputs;
      };
    });
}
