{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  home.file = {
    "mtmr" = {
      target = ".config/mtmr";
      source = ../dotfiles/mtmr;
    };
    "espanso-config" = {
      target = ".config/espanso/config/default.yml";
      source = ../dotfiles/espanso/config/default.yml;
    };
    "espanso-match-base" = {
      target = ".config/espanso/match/base.yml";
      source = ../dotfiles/espanso/match/base.yml;
    };
    "espanso-match-english" = {
      target = ".config/espanso/match/english.yml";
      source = ../dotfiles/espanso/match/english.yml;
    };
    "karabiner" = {
      target = ".config/karabiner";
      source = ../dotfiles/karabiner;
    };
    "direnvrc" = {
      target = ".config/direnv/direnvrc";
      source = ../dotfiles/direnvrc;
    };
    "colemak" = {
      target = "Library/Keyboard Layouts/Colemak_DH.bundle";
      source = ../dotfiles/Colemak_DH.bundle;
    };
    "defaultkeybinding" = {
      target = "Library/KeyBindings/DefaultKeyBinding.dict";
      source = ../dotfiles/DefaultKeyBinding.dict;
    };
    "raycast-scripts" = {
      target = ".config/raycast/scripts";
      source = ../dotfiles/raycast;
    };
    "share-pandoc" = {
      target = ".local/share/pandoc";
      source = ../share/pandoc;
    };
    "share-lua" = {
      target = ".local/share/lua";
      source = ../share/lua;
    };
    "scripts" = {
      target = ".local/bin";
      source = ../scripts;
      executable = true;
      recursive = true;
    };
    "emacs-app" = {
      target = "Applications/Emacs.app";
      source = ../dotfiles/Emacs.app;
    };
  };
}
