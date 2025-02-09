{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  name = "kindletool";
  version = "v1.6.5";
  src = fetchFromGitHub {
    owner = "NiLuJe";
    repo = "KindleTool";
    tag = version;
    hash = "sha256-Io+tfwgRAPEx+TQKZLBGrrHGAVS6ndgOOh+KlBh4t2U=";
  };
  nativeBuildInputs = with pkgs; [
    pkg-config
    inetutils
  ];
  buildInputs = with pkgs; [
    libarchive
    gmp
    nettle
    zlib
  ];
  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];
}
