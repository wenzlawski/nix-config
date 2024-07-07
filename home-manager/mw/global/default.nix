{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};

  homeDirectory =
    if isDarwin
    then "/Users/mw"
    else "/home/mw";
in {
  imports = [
    ./accounts.nix
    ./dotfiles.nix
    ../features/cli
    ../features/desktop
  ];
  # ++ (nur-no-pkgs.repos.moredhel.hmModules.rawModules);

  nixpkgs = {
    overlays = [
      # outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.emacs-overlay.overlay
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
      ];
    };
  };

  home = {
    username = "mw";
    inherit homeDirectory;
    sessionVariables = {
      EDITOR = "emacsclient -nc";
      # TERMINAL = lib.mkDefault "wezterm";
      # COLORTERM = lib.mkDefault "truecolor";
      # BROWSER = lib.mkDefault "firefox";
    };
  };

  programs.home-manager.enable = true;

  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
