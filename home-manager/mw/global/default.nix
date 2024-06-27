{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  homeDirectory =
    if isDarwin
    then "/Users/mw"
    else "/home/mw";
in {
  imports = [
    ./accounts.nix
    ./dotfiles.nix
    ../features/cli
  ];
  # ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = [
      # outputs.overlays.additions
      # outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # inputs.nur.overlay
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
      EDITOR = "emacs";
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
