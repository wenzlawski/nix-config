{
  lib,
  stdenv,
  makeWrapper,
  buildEnv,
}: let
  mkBorgScript = tool: src: deps:
    stdenv.mkDerivation {
      name = "borg-${tool}";

      nativeBuildInputs = [makeWrapper];

      dontUnpack = true;

      installPhase = ''
        install -vD ${src} $out/bin/$name;
        wrapProgram $out/bin/$name \
          --prefix PATH : ${lib.makeSearchPath "borg" ["/usr/local"]} \
      '';

      preferLocalBuild = true;

      meta = with lib; {
        description = "Script used to obtain source hashes for fetch${tool}";
        platforms = platforms.unix;
      };
    };
in rec {
  # TODO: Use env vars instead of a conf script.
  borg-script-list = mkBorgScript "list" ./borg-list [];
  borg-script-compact = mkBorgScript "compact" ./borg-compact [];
  borg-script-info = mkBorgScript "info" ./borg-info [];
  borg-script-keyexport = mkBorgScript "keyexport" ./borg-keyexport [];
  borg-script-mount = mkBorgScript "mount" ./borg-mount [];
  borg-script-recreate = mkBorgScript "recreate" ./borg-recreate [];

  borg-scripts = buildEnv {
    name = "borg-scripts";

    paths = [
      borg-script-list
      borg-script-compact
      borg-script-info
      borg-script-keyexport
      borg-script-mount
      borg-script-recreate
    ];

    meta = with lib; {
      description = "Collection of all the borg-* scripts which may be used to interact with borg";
      platforms = platforms.unix;
    };
  };
}
