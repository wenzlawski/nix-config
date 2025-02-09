{
  config,
  pkgs,
  ...
}: let
  aspell' = pkgs.aspellWithDicts (d: [d.en d.de]);
  # emacs-30 = import ./emacs.nix;

  stable-packages = with pkgs.unstable; [
    inetutils
    mailutils
    nodePackages.live-server
    wkhtmltopdf
    typst
    aspell'
    csslint
    stylelint
    dateutils
    alejandra
    asymptote
    brotab
    enchant
    alt-tab-macos
    anki-bin
    # bitwarden-cli
    shfmt
    bottom
    cmake
    coreutils-prefixed
    curl
    disk-inventory-x
    # dust
    # duti # is broken
    fd
    colmena
    findutils
    gawk
    ghostscript
    gnugrep
    gnumake
    gnupg
    # qt5.qtbase
    graphviz
    groff
    hledger
    httpie
    iina
    imagemagick
    isync
    jq
    just
    ledger
    less
    libreoffice-bin
    neovim
    net-news-wire
    ninja
    nix-your-shell
    nixfmt-classic
    nixpkgs-fmt
    nodePackages.prettier
    nodePackages.svgo
    # notmuch
    pdftk
    poppler_utils
    ripgrep
    ripgrep-all
    sbclPackages.clhs
    silver-searcher
    spicetify-cli
    tectonic
    tmux
    # transmission_3
    tre-command
    tree
    w3m
    wget
    yt-dlp
    zellij
    sshfs
    nix-prefetch-git
    telegram-desktop
    kubectl
    kubernetes-helm
    # man-pages
    # man-pages-posix
  ];

  unstable-packages = with pkgs; [
  ];
in {
  imports = [
    ./fish.nix
    ./git.nix
    ./ssh.nix
    #./xpo.nix
    #./emacs.nix
  ];

  home.shellAliases = {
    sbcl-ql = "sbcl --noinform --load $HOME/quicklisp/setup.lisp";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++ (with pkgs.local-pkgs; [
      testhello
      alerter
      yabai-tile
      borg-scripts
      rembg
      kindletool
    ]);

  editorconfig.enable = true;

  programs = {
    bat = {
      enable = true;
      config.theme = "TwoDark";
    };

    man = {
      enable = false;
      generateCaches = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
      };
      stdlib = ''
        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="''$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
        }
      '';
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
    };

    broot = {
      enable = true;
      enableFishIntegration = true;
    };

    pandoc = {
      enable = true;
      defaults = {
      };
    };

    alacritty = {
      enable = true;
      settings = {
        font.size = 14;
        font.normal.family = "DejaVuSansM Nerd Font";
        window = {
          dimensions = {
            columns = 80;
            lines = 35;
          };
          decorations_theme_variant = "Dark";
          decorations = "buttonless";
          padding = {
            x = 5;
            y = 5;
          };
          resize_increments = true;
          option_as_alt = "Both";
          dynamic_padding = true;
        };
        terminal.shell = {
          program = "${pkgs.fish}/bin/fish";
          args = ["-l"];
        };
      };
    };

    texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit
          (tpkgs)
          scheme-small
          soul
          lualatex-math
          selnolig
          collection-fontsrecommended
          latex-fonts
          courier
          microtype
          parskip
          graphics
          latexmk
          wrapfig
          capt-of
          dvisvgm
          ;
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [];
    };

    afew = {
      enable = true;
      extraConfig = builtins.readFile ./afew.toml;
    };

    lieer.enable = true;

    notmuch = {
      enable = true;
      new.tags = [
        "new"
      ];
      new.ignore = ["/.*[.](json|lock|bak)$/"];
      hooks.preNew = ''
        ${pkgs.afew}/bin/afew --move --all --notmuch-args=--no-hooks
        ${pkgs.isync}/bin/mbsync -a
      '';

      hooks.postNew = ''
        ${pkgs.afew}/bin/afew --tag --new
      '';
    };

    mbsync.enable = true;
    mbsync.package = pkgs.unstable.isync;
    msmtp.enable = true;
    msmtp.package = pkgs.unstable.msmtp;

    khal = {
      enable = true;
      package = pkgs.khal;
      locale = {
        timeformat = "%H:%M";
        # dateformat = "%d.%m.";
        dateformat = "%Y-%m-%d";
        longdateformat = "%Y-%m-%d %a"; # %a
        # datetimeformat = "%d.%m. %H:%M";
        datetimeformat = "%Y-%m-%d %H:%M";
        longdatetimeformat = "%Y-%m-%d %H:%M";
      };
    };
    khard = {
      enable = true;
      settings = {
        general = {
          default_action = "list";
          editor = [
            "emacsclient"
            "-nc"
          ];
        };

        "contact table" = {
          display = "formatted_name";
          preferred_phone_number_type = [
            "pref"
            "cell"
            "home"
          ];
          preferred_email_address_type = [
            "pref"
            "work"
            "home"
          ];
        };
      };
    };

    vdirsyncer.enable = true;
  };

  nixpkgs.config = import ./nixpkgs-config.nix;
  home.file = {
    "nixpkgs-config" = {
      target = ".config/nixpkgs/config.nix";
      source = ./nixpkgs-config.nix;
    };
  };
}
