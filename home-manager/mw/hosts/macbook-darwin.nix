{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../global
  ];

  home.sessionPath = ["/opt/homebrew/bin/"];
}
