{pkgs, ...}: let
in
  pkgs.writeShellScriptBin "testhello" ''
    echo "Hello World!"
  ''
