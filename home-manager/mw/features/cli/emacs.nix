{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) fetchpatch;
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = "/Users/mw/.config/emacs/init.el";
      extraEmacsPackages = epkgs: [
        epkgs.vterm
      ];

      package =
        (pkgs.emacs-unstable.override {
          withNativeCompilation = true;
        })
        .overrideAttrs (old: {
          src = pkgs.fetchFromSavannah {
            repo = "emacs";
            # rev = "emacs-29.4";
            rev = "4d21dff571477ca0308293815f3025897bc089a4";
            # hash = "sha256-MQ0A4Nlagt2VSENcAAk4A1oju3ebAExiVgga7k6kRW4=";
            sha256 = "1mdfz70ym8slcpqycmpxy0f3dhdrs7vnd9qabd88q7gm7hncaw6c";

            # sha256 = "0sv7g106g48bwbwwypcr59r8wbd1kxzgdx34lwfn1xhd574zl8ql";
          };
          version = 30.0;
          name = "emacs-unstable-30.0";
          configureFlags =
            old.configureFlags
            ++ [
              (lib.withFeature true "poll")
            ];
          patches =
            (old.patches or [])
            ++ [
              # Fix OS window role (needed for window managers like yabai)
              (fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
                sha256 = "0c41rgpi19vr9ai740g09lka3nkjk48ppqyqdnncjrkfgvm2710z";
              })
              # Use poll instead of select to get file descriptors
              (fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/poll.patch";
                sha256 = "1rmkijklyqm6i2zv4xyry6mmp6r5qxgbyfry8mnkpyih51m6vdri";
              })
              # Enable rounded window with no decoration
              (fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
                sha256 = "0x187xvjakm2730d1wcqbz2sny07238mabh5d97fah4qal7zhlbl";
              })
              # Make Emacs aware of OS-level light/dark mode
              (fetchpatch {
                url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
                sha256 = "1dkx8xc3v2zgnh6fpx29cf6kc5h18f9misxsdvwvy980cj0cxcwy";
              })
            ];
        });
    };
  };
}
