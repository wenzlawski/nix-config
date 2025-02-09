{
  lib,
  python3,
  fetchPypi,
  khard,
  testers,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  name = "auctionwatcher";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "wenzlawski";
    repo = name;
    rev = "218bae639a5b6961b8fca7fb2406d364900e3151";
    hash = "sha256-HO9nPVf2Pdl5WMQmFrt0GCDKUvzTxFAqFmaDOO7o2UU=";
  };
  format = "pyproject";

  propagatedBuildInputs = with python3.pkgs; [
    scrapy
    jinja2
    humanize
    dateparser
    platformdirs
  ];

  pythonImportsCheck = [
    "auctionwatcher"
  ];

  postFixup = ''
    wrapProgram $out/bin/auctionwatcher --set SCRAPY_SETTINGS_MODULE auctionwatcher.settings
  '';
}
