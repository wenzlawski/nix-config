{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  replaceString = builtins.replaceStrings ["emacsclient"] ["${pkgs.emacs-30withpkgs}/bin/emacsclient"];
  patchedText = replaceString (builtins.readFile ./mtmr.json);
  patchedFile = pkgs.writeText "item.json" patchedText;
in let
  configFilesToLink = {
    "mtmr/items.json" = "${patchedFile}";
    "espanso/config/default.yml" = ./espanso/config/default.yml;
    "espanso/match/base.yml" = ./espanso/match/base.yml;
    "espanso/match/english.yml" = ./espanso/match/english.yml;
    "karabiner" = ./karabiner;
    "direnv/direnvrc" = ./direnvrc;
    "raycast/scripts" = ./raycast-scripts;
    "gnuplot/gnuplotrc" = ./gnuplotrc;
    "fish/conf.d/vfish.fish" = ./fish/conf.d/vfish.fish;
  };

  homeFilesToLink = {
    "Library/Keyboard Layouts/Colemak_DH.bundle" = ./Colemak_DH.bundle;
    "Library/KeyBindings/DefaultKeyBinding.dict" = ./DefaultKeyBinding.dict;
    # "Applications/Emacs.app" = ./Emacs.app;
  };

  dataFilesToLink = {
    "pandoc" = ./pandoc;
    "lua" = ./lua;
  };

  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
in {
  home.preferXdgDirectories = true;

  home.file = pkgs.lib.attrsets.mapAttrs toSource homeFilesToLink;
  xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
  xdg.dataFile = pkgs.lib.attrsets.mapAttrs toSource dataFilesToLink;
}
