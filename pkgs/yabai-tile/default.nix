{stdenv}:
stdenv.mkDerivation {
  version = "unset";
  pname = "yabai-tile";
  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -Dv yabai-tile.sh $out/bin/yabai-tile
    chmod +x $out/bin/yabai-tile
  '';
}
