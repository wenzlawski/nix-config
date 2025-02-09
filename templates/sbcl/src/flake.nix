{
  description = "test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        src = ./.;

        sbcl' = pkgs.sbcl.withPackages (ps:
          with ps; [
          ]);

        shellInputs = with pkgs; [
        ];
        appNativeBuildInputs = with pkgs; [
          pkg-config
          makeWrapper
        ];
        appBuildInputs = with pkgs; [
          sbcl'
        ];
        appRuntimeInputs = with pkgs; [];
      in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = appNativeBuildInputs;
          buildInputs = shellInputs ++ appBuildInputs;

          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath appRuntimeInputs}"
          '';
        };
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "test";
          version = "0.1.0";

          src = src;

          nativeBuildInputs = appNativeBuildInputs;
          buildInputs = appBuildInputs;

          buildPhase = ''
            export HOME=$(pwd)
            ${sbcl'}/bin/sbcl --load build.lisp
          '';

          # cp target/debug/tfcapi $out/bin
          installPhase = ''
            mkdir -p $out/bin
            cp -v test $out/bin
            wrapProgram $out/bin/test \
              --prefix LD_LIBRARY_PATH : $LD_LIBRARY_PATH \
          '';
        };
      }
    );
}
