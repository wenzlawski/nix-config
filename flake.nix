{
  description = "dotfiles";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-platforms = "x86_64-linux";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";

    nur.url = "github:nix-community/NUR";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    # emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # emacs-plus.url = "github:d12frosted/homebrew-emacs-plus";
    # emacs-plus.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    agenix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

    nixpkgsWithOverlays = system: let
      pkgs =
        if builtins.elem system darwinSystems
        then inputs.nixpkgs-darwin
        else nixpkgs;
    in (import pkgs rec {
      inherit system;

      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
        ];
      };

      overlays = [
        inputs.nur.overlays.default
        (_final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            inherit config;
          };
          gnuplot = prev.gnuplot.override {
            withQt = true;
            withWxGTK = true;
          };
          khal = prev.khal.overrideAttrs (old: {
            src = prev.fetchFromGitHub {
              owner = old.src.owner;
              repo = old.src.repo;
              rev = "4b6e79912eca9c3fcba8415d4e0c18d87e9d13f4";
              hash = "sha256-Cb0FM7K9F9Coo/1cMkEiMnRoaNmUKnpShRNvLZpGH+g=";
            };
          });
          local-pkgs = import ./pkgs {pkgs = _final;};
        })
      ];
    });

    mkNixos = system: modules:
      nixpkgs.lib.nixosSystem {
        inherit modules;
        pkgs = nixpkgsWithOverlays system;
        specialArgs = {inherit inputs outputs self;};
      };

    mkDarwin = system: modules:
      inputs.darwin.lib.darwinSystem {
        inherit modules system;
        pkgs = nixpkgsWithOverlays system;
        specialArgs = {inherit inputs outputs self;};
      };

    mkHome = modules: pkgs:
      home-manager.lib.homeManagerConfiguration {
        inherit modules;
        extraSpecialArgs = {inherit inputs outputs self;};
      };
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./pkgs {inherit pkgs;});

    overlays = import ./overlays {inherit inputs self;};

    checks = forAllSystems (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = nixpkgs.lib.path.append ./.;
        hooks = {alejandra.enable = true;};
      };
    });

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs =
          self.checks.${system}.pre-commit-check.enabledPackages
          ++ (with pkgs; [nixd]);
      };
    });

    formatter = forAllSystems (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );

    templates = {
      sbcl = {
        path = ./templates/sbcl;
        description = "SBCL template";
      };
    };

    # nixosModules = import ./modules/nixos;

    homeManagerModules = import ./modules/home-manager;

    # home-manager = {
    #   useGlobalPkgs = true;
    #   useUserPackages = true;
    #   extraSpecialArgs = {};
    #   users.mw.imports = [
    #     ./modules/home-manager
    #     # ./modules/spicetify # no support for macOS atm
    #   ];
    #   formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.nixpkgs-fmt;

    darwinConfigurations = {
      Marcs-MacBook-Pro = mkDarwin "x86_64-darwin" [./darwin/macbook.nix];
    };

    nixosConfigurations = {
      my-hetzner-vm =
        mkNixos "x86_64-linux"
        [./hetzner inputs.disko.nixosModules.disko];
      # my-hetzner-vm = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";

      #   modules = [
      #     ./hetzner
      #     inputs.disko.nixosModules.disko
      #   ];
      # };
    };

    colmenaHive = inputs.colmena.lib.makeHive self.outputs.colmena;

    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      };

      # Also see the non-Flakes hive.nix example above.
      hetzner-vm = {
        deployment = {
          targetHost = "188.245.177.59";
          targetUser = "root";
          buildOnTarget = true;
        };
        imports = [
          ./hetzner
          inputs.disko.nixosModules.disko
        ];
      };
    };
  };
}
