{
  description = "A flake for a meson project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          myapp = pkgs.stdenv.mkDerivation rec {
            name = "myapp";
            version = "0.0.1";
            src = ./.;
            propagatedBuildInputs = with pkgs; [
              meson
              ninja
              pkg-config
            ];
          };
          default = myapp;
        };

        apps = rec {
          myapp = flake-utils.lib.mkApp {
            drv = self.packages.${system}.myapp;
            name = "myapp";
          };
          default = myapp;
        };
      }
    );
}
