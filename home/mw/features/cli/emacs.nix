{
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [epkgs.vterm epkgs.jinx];
    package =
      (pkgs.emacs-unstable.override {
        withNativeCompilation = true;
      })
      .overrideAttrs
      (old: {
        src = pkgs.fetchFromGitHub {
          owner = "emacs-mirror";
          repo = "emacs";
          # rev = "emacs-29.4";
          rev = "9a1c76bf7ff49d886cc8e1a3f360d71e62544802";
          #hash = "sha256-YPQvfX7TI6b4p7bP2oCehOhDRrvF1LjlzOHTDUArBYY=";
          hash = "sha256-X5J34BUY42JgA1s76eVeGA9WNtesU2c+JyndIHFbONQ=";
        };
        version = 30.0;
        name = "emacs-unstable-30.0.90";
        configureFlags =
          old.configureFlags
          ++ [
            (lib.withFeature true "poll")
          ];
        patches =
          (lib.optionals pkgs.stdenv.isDarwin [
            "${inputs.emacs-plus}/patches/emacs-30/fix-window-role.patch"
            "${inputs.emacs-plus}/patches/emacs-30/poll.patch"
            "${inputs.emacs-plus}/patches/emacs-30/round-undecorated-frame.patch"
            "${inputs.emacs-plus}/patches/emacs-30/system-appearance.patch"
          ])
          ++ old.patches;
      });
  };
}
