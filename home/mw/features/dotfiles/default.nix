{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  configFilesToLink = {
    "mtmr/items.json" = ./mtmr.json;
    "espanso/config/default.yml" = ./espanso/config/default.yml;
    "espanso/match/base.yml" = ./espanso/match/base.yml;
    "espanso/match/english.yml" = ./espanso/match/english.yml;
    "karabiner" = ./karabiner;
    "raycast/scripts" = ./raycast-scripts;
    "gnuplot/gnuplotrc" = ./gnuplotrc;
    "fish/conf.d/vfish.fish" = ./vfish.fish;
    "afew/SubAddressFilter.py" = ./afew/SubAddressFilter.py;
  };

  homeFilesToLink = {
    "Library/KeyBindings/DefaultKeyBinding.dict" = ./DefaultKeyBinding.dict;
    "~/Library/Application Support/librewolf/NativeMessagingHosts/brotab_mediator.json" = ./brotab_mediator.json;
    ".manpath" = ./.manpath;
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
