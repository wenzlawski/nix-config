{
  config,
  pkgs,
  ...
}: let
in {
  imports = [
    ./librewolf.nix
  ];

  home.keyboard = {
    layout = "io.github.colemakmods.keyboardlayout.colemakdh.colemakdhmatrix";
  };
}
