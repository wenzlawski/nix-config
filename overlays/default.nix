# This file defines overlays
{
  inputs,
  self,
  ...
}: {
  # This one brings our custom packages from the 'pkgs' directory
  # borg = self.callPackage ./borg { };
  additions = final: _prev: {
    # nest everything under a namespace that's not likely to collide
    # with anything in nixpkgs
    local-pkgs = import ../pkgs {pkgs = final;};
  };

  modifications = final: prev: {
    gnuplot = prev.gnuplot.override {
      withQt = true;
      withWxGTK = true;
    };
    khal = prev.khal.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = old.src.owner;
        repo = old.src.repo;
        rev = "4b6e79912eca9c3fcba8415d4e0c18d87e9d13f4";
        hash = "sha256-Cb0FM7K9F9Coo/1cMkEiMnRoaNmUKnpShRNvLZpGH+g=";
      };
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
