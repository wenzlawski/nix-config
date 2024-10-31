{
  pkgs,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation {
  name = "alerter";
  version = "1.0.0";
  src = fetchzip {
    url = "https://github.com/vjeantet/alerter/releases/download/1.0.0/alerter_v1.0.0_darwin_amd64.zip";
    hash = "sha256-XEmH8Co9elNVTCx/GD+jphTn+1OtlD6Q7CkgI+J5yxg=";
  };

  nativeBuildInputs = [pkgs.unzip];

  installPhase = ''
    mkdir -p $out/bin
    cp alerter $out/bin
    chmod +x $out/bin/alerter
  '';
}
