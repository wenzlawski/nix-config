{
  description = "dotfiles";
  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Spicetify
    # spicetify-nix.url = "github:the-argus/spicetify-nix";

    agenix.url = "github:ryantm/agenix";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    agenix,
    ...
  } @ inputs: let
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
    devShell = system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = with pkgs;
        mkShell {
          nativeBuildInputs = with pkgs; [
            bashInteractive
            git
            age
            age-plugin-yubikey
          ];
          shellHook = with pkgs; ''
            export EDITOR=emacs
          '';
        };
    };
    pkgs = import nixpkgs {
      system = "x86_64-darwin";
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          khal = prev.khal.overrideAttrs (old: {
            src = prev.fetchFromGitHub {
              owner = "pimutils";
              repo = "khal";
              rev = "4b6e79912eca9c3fcba8415d4e0c18d87e9d13f4";
              # If you don't know the hash, the first time, set:
              # hash = "";
              # then nix will fail the build with such an error message:
              # hash mismatch in fixed-output derivation '/nix/store/m1ga09c0z1a6n7rj8ky3s31dpgalsn0n-source':
              # specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
              # got:    sha256-173gxk0ymiw94glyjzjizp8bv8g72gwkjhacigd1an09jshdrjb4
              hash = "sha256-Cb0FM7K9F9Coo/1cMkEiMnRoaNmUKnpShRNvLZpGH+g=";
            };
          });
        })
        # (final: prev: {
        #   msmtp = prev.msmtp.scripts.overrideAttrs (old: {
        #     patches =
        #       (old.patches or [])
        #       ++ [
        #         ./modules/home-manager/share/msmtpq.patch
        #       ];
        #   });
        # })
      ];
    };
    mkApp = scriptName: system: {
      type = "app";
      program = "${
        (nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')
      }/bin/${scriptName}";
    };
    mkLinuxApps = system: {
      "apply" = mkApp "apply" system;
      "build-switch" = mkApp "build-switch" system;
      "copy-keys" = mkApp "copy-keys" system;
      "create-keys" = mkApp "create-keys" system;
      "check-keys" = mkApp "check-keys" system;
      "install" = mkApp "install" system;
      "install-with-secrets" = mkApp "install-with-secrets" system;
    };
    mkDarwinApps = system: {
      # "apply" = mkApp "apply" system;
      # "build" = mkApp "build" system;
      # "build-switch" = mkApp "build-switch" system;
      # "copy-keys" = mkApp "copy-keys" system;
      "create-keys" = mkApp "create-keys" system;
      # "check-keys" = mkApp "check-keys" system;
      # "rollback" = mkApp "rollback" system;
    };
  in {
    devShells = forAllSystems devShell;
    apps =
      nixpkgs.lib.genAttrs linuxSystems mkLinuxApps
      // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;
    formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.nixpkgs-fmt;

    darwinConfigurations."Marcs-MacBook-Pro" = darwin.lib.darwinSystem {
      inherit pkgs;
      specialArgs = inputs;
      system = "x86_64-darwin";
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {};
            users.mw.imports = [
              ./modules/home-manager
              # ./modules/spicetify # no support for macOS atm
            ];
          };
        }
      ];
    };
  };
}
