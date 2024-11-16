{
  description = "dotfiles";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify
    # spicetify-nix.url = "github:the-argus/spicetify-nix";

    agenix.url = "github:ryantm/agenix";

    nur.url = "github:nix-community/NUR";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };
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

    mkNixos = modules:
      nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = {inherit inputs outputs self;};
      };

    mkDarwin = system: modules:
      inputs.darwin.lib.darwinSystem {
        inherit modules system;
        specialArgs = {inherit inputs outputs self;};
      };

    mkHome = modules: pkgs:
      home-manager.lib.homeManagerConfiguration {
        inherit modules pkgs;
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
      # alejandra is a nix formatter with a beautiful output
      system: nixpkgs.legacyPackages.${system}.alejandra
    );

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
  };
}
