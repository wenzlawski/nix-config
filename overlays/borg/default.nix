{
  pkgs,
  bash,
  symlinkJoin,
  resholve,
  coreutils,
  lib,
}: let
  inherit (lib) getBin getExe genAttrs optionals;

  script =
    resholve.writeScriptBin "borg-backup" {
      inputs = [
        coreutils
      ];
      interpreter = getExe bash;
    } ''
      echo "hello from the other side"
    '';
in
  symlinkJoin {
    name = "borg";
    paths = [
      bash
      coreutils
    ];
    postBuild = ''
      cp ${script} $out/bin/borg-backup
      wrapProgram $out/bin/borg-backup --set PATH $out/bin
    '';
  }
