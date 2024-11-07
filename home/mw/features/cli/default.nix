{
  config,
  pkgs,
  ...
}: let
in
  # emacs-30 = import ./emacs.nix;
  {
    imports = [
      ./fish.nix
      ./git.nix
      ./ssh.nix
      #./xpo.nix
      #./emacs.nix
    ];

    home.packages = with pkgs; [
      # local-pkgs.testhello
      # local-pkgs.xpo
      local-pkgs.testhello
      local-pkgs.alerter
      local-pkgs.yabai-tile
      local-pkgs.borg-scripts
      inetutils
      mailutils
      csslint
      stylelint
      dateutils
      alejandra
      asymptote
      enchant
      alt-tab-macos
      anki-bin
      # bitwarden-cli
      shfmt
      bottom
      broot
      cmake
      coreutils-prefixed
      curl
      disk-inventory-x
      dust
      duti
      eza
      fd
      findutils
      gawk
      ghostscript
      gnugrep
      gnumake
      gnupg
      gnuplot
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
      transmission_3
      tre-command
      tree
      w3m
      wget
      yt-dlp
      zellij
      zoxide
      sshfs
      nix-prefetch-git
      # man-pages
      # man-pages-posix
    ];

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

      pandoc = {
        enable = true;
        defaults = {
          pdf-engine = "xelatex";
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
      msmtp.enable = true;
      msmtp.package = pkgs.msmtp;
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
