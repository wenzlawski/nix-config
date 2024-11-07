{
  pkgs,
  resholve,
  lib,
}: let
  scripts = [
    "borg-backup"
    "borg-compact"
    "borg-info"
    "borg-init"
    "borg-keyexport"
    "borg-list"
    "borg-mount"
    "borg-recreate"
  ];
  bin-scripts = lib.map (x: "bin/${x}") scripts;
in
  resholve.mkDerivation rec {
    pname = "borg-scripts";
    version = "unset";

    src = ./.;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      install -Dm555 -t $out/bin borg-*
    '';

    solutions = {
      default = {
        scripts = bin-scripts;
        interpreter = "${pkgs.bash}/bin/bash";
        inputs = with pkgs; [coreutils];
        keep.source = ["$HOME"];
        fake.external = ["borg" "ssh"];
      };
    };
  }
