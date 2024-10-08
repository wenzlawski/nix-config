{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) fetchpatch;
in
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
      # hash = "sha256-MQ0A4Nlagt2VSENcAAk4A1oju3ebAExiVgga7k6kRW4=";
      sha256 = "11h55d00vlz1rkjvim65pd347s44ks0dmkxnlzwac8ykgryjzx30";

      # sha256 = "0sv7g106g48bwbwwypcr59r8wbd1kxzgdx34lwfn1xhd574zl8ql";
    };
    version = 30.0;
    name = "emacs-unstable-30.0";
    configureFlags =
      old.configureFlags
      ++ [
        (lib.withFeature true "poll")
      ];
    # patches =
    #   (lib.optionals pkgs.stdenv.isDarwin [
    #     "${inputs.emacs-plus}/patches/emacs-30/fix-window-role.patch"
    #     "${inputs.emacs-plus}/patches/emacs-30/poll.patch"
    #     "${inputs.emacs-plus}/patches/emacs-30/round-undecorated-frame.patch"
    #     "${inputs.emacs-plus}/patches/emacs-30/system-appearance.patch"
    #   ])
    #   ++ old.patches;
    patches =
      [
        # Fix OS window role (needed for window managers like yabai)
        (fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
          hash = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
        })
        # Use poll instead of select to get file descriptors
        # (fetchpatch {
        #   url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/poll.patch";
        #   hash = "sha256-bQW9LPmJhMAtP2rftndTdjw0uipPyOp5oXqtIcs7i/Q=";

        # })
        # Enable rounded window with no decoration
        (fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
          hash = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
        })
        # Make Emacs aware of OS-level light/dark mode
        (fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
          hash = "sha256-3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
        })
      ]
      ++ (old.patches or []);
  })
