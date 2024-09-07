{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs) nixpkgs;
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.agenix.darwinModules.default
    # ../fonts.nix
    ./system.nix
  ];

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  users.users.mw = {
    name = "mw";
    home = "/Users/mw";
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = [
      pkgs.coreutils
      pkgs.vim
      pkgs.fish
      pkgs.zsh
      inputs.agenix.packages.${pkgs.stdenv.system}.default
    ];
    shells = builtins.attrValues {
      inherit
        (pkgs)
        bash
        bashInteractive
        zsh
        fish
        ;
    };
    systemPath = ["/usr/local/bin"];
    pathsToLink = ["/Applications"];
    variables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      LANG = "en_US.UTF-8";
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    set -gx PATH /run/current-system/sw/bin $HOME/.nix-profile/bin $PATH
  '';

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  nix.extraOptions =
    ''
      experimental-features = nix-command flakes repl-flake
    ''
    + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

  # pin nixpkgs in the system flake registry to the revision used
  # to build the config
  nix.registry.nixpkgs.flake = nixpkgs;
  nix.settings.trusted-users = [
    "root"
    "mw"
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.overlays = [
    (
      final: prev:
        lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import nixpkgs {
            system = "x86_64-darwin";
            config.allowUnfree = true;
          };
        }
    )
  ];

  system.stateVersion = 4;
}
