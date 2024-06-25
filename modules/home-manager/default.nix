{
  pkgs,
  lib,
  ...
}: let
  sbcl' = pkgs.sbcl.withPackages (ps: [ps.clhs]);
in {
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";

  # specify my home-manager configs
  home.packages = with pkgs; [
    # bruno # build fails
    # calibre # broken?
    inetutils
    alejandra
    alt-tab-macos
    anki-bin
    bitwarden-cli
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
    notmuch
    pdftk
    poppler_utils
    raycast
    ripgrep
    ripgrep-all
    sbclPackages.clhs
    silver-searcher
    spicetify-cli
    tectonic
    tmux
    transmission
    tre-command
    tree
    w3m
    wget
    yt-dlp
    zellij
    zoxide
    sshfs
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "emacs";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  editorconfig.enable = true;
  programs = {
    bash.enable = true;
    zsh.enable = true;

    eza.enable = true;
    git = {
      enable = true;
      userEmail = "marc.wenzlawski@outlook.de";
      userName = "Marc Wenzlawski";
      ignores = [".DS_Store"];
    };
    bat = {
      enable = true;
      config.theme = "TwoDark";
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {hide_env_diff = true;};
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        set pure_enable_nixdevshell true
        set -g NIX_BUILD_SHELL $SHELL
        set -g LUA_PATH "$HOME/.local/share/lua/?.lua;;"
        if command -q nix-your-shell
          nix-your-shell fish | source
        end
      '';
      loginShellInit = "";
      shellAliases = lib.mkForce {alejandra = "alejandra -q";};
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          name = "tide";
          src = pkgs.fishPlugins.tide.src;
        }
      ];
    };
    pandoc = {
      enable = true;
      defaults = {pdf-engine = "xelatex";};
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "borg" = {
          user = "u411549-sub1";
          hostname = "u411549.your-storagebox.de";
          identityFile = "~/.ssh/id_ed25519_hetznerbackup";
          port = 23;
        };
        "storage" = {
          user = "u411549-sub2";
          hostname = "u411549.your-storagebox.de";
          identityFile = "~/.ssh/id_ed25519";
          port = 23;
        };
        "u411549.your-storagebox.de" = {
          identityFile = "~/.ssh/id_ed25519";
          port = 23;
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
          extraOptions = {
            "AddKeysToAgent" = "yes";
            "UseKeychain" = "yes";
          };
        };
      };
    };

    alacritty = {
      enable = true;
      settings = {
        font.size = 18;
        font.normal.family = "Iosevka Nerd Font";
        window = {
          dimensions = {
            columns = 80;
            lines = 35;
          };
          decorations_theme_variant = "Dark";
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
          ;
      };
    };

    afew = {
      enable = true;
      extraConfig = ''
        [SpamFilter]
        [KillThreadsFilter]
        [ListMailsFilter]
        [ArchiveSentMailsFilter]
        sent_tag = sent
        [MeFilter]
        [InboxFilter]
      '';
    };
    notmuch = {
      enable = true;
      new.tags = [
        "new"
      ];
      hooks.preNew = "/etc/profiles/per-user/mw/bin/mbsync -a";
      #   # remove "unread" from "replied"
      #   notmuch tag -unread -new -- tag:replied

      #   # tag all "new" messages "inbox" and "unread"
      #   notmuch tag +inbox +unread -new -- tag:new

      #   # tag my replies as "sent"
      #   notmuch tag -new -unread +inbox +sent -- '(from:"marcwenzlawski@posteo.com*" not to:"marcwenzlawski@posteo.com*" not tag:list not tag:archived)'

      #   notmuch tag -inbox +list +emacs -- from:emacs-devel@gnu.org or to:emacs-devel@gnu.org
      #   notmuch tag -inbox +list +emacs -- from:emacs-orgmode@gnu.org or to:emacs-orgmode@gnu.org
      #   notmuch tag -inbox +list +emacs -- 'to:"/*@debbugs.gnu.org*/"'
      #   notmuch tag -inbox +list +emacs -- from:emacs-humanities@gnu.org or to:emacs-humanities@gnu.org not to:emacs-humanities-owner@gnu.org
      hooks.postNew = ''
        /etc/profiles/per-user/mw/bin/afew --tag --new
      '';
    };

    mbsync.enable = true;
    msmtp.enable = true;
    khal = {
      enable = true;
      locale = {
        timeformat = "%H:%M";
        dateformat = "%d.%m.";
        longdateformat = "%Y-%m-%d";
        datetimeformat = "%d.%m. %H:%M";
        longdatetimeformat = "%Y-%m-%d %H:%M";
      };
    };
    khard = {
      enable = true;
      settings = {
        general = {
          default_action = "list";
          editor = ["emacs" "-nc"];
        };

        "contact table" = {
          display = "formatted_name";
          preferred_phone_number_type = ["pref" "cell" "home"];
          preferred_email_address_type = ["pref" "work" "home"];
        };
      };
    };

    vdirsyncer.enable = true;
  };

  accounts = {
    email = {
      accounts.icloud = {
        primary = true;
        address = "marc.wenzlawski@icloud.com";
        realName = "Marc Wenzlawski";
        userName = "marc.wenzlawski@icloud.com";
        # gpg = {
        #   key = "";
        #   signByDefault = true;
        # };
        imap = {
          host = "imap.mail.me.com";
          port = 993;
          tls = {enable = true;};
        };
        smtp = {
          host = "smtp.mail.me.com";
          port = 587;
          tls.enable = true;
          tls.useStartTls = true;
        };
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        signature = {
          text = ''
            Mit besten Wuenschen
            Marc Wenzlawski
          '';
          showSignature = "append";
        };
        passwordCommand = "security find-generic-password -s mbsync-icloud-password -w";
      };

      accounts.posteo = {
        address = "marcwenzlawski@posteo.com";
        realName = "Marc Wenzlawski";
        userName = "marcwenzlawski@posteo.com";
        imap = {
          host = "posteo.de";
          port = 993;
        };
        smtp = {host = "posteo.de";};
        mbsync = {
          enable = true;
          create = "maildir";
        };
        msmtp.enable = true;
        notmuch.enable = true;
        passwordCommand = "security find-generic-password -s mbsync-posteo-password -w";
      };
    };

    contact = {
      basePath = ".contacts";
      accounts.posteo = {
        local = {
          type = "filesystem";
          fileExt = ".vcf";
        };
        remote = {
          userName = "marcwenzlawski@posteo.com";
          url = "https://posteo.de:8843/addressbooks/marcwenzlawski/default";
          type = "carddav";
          passwordCommand = [
            "security"
            "find-generic-password"
            "-s"
            "posteo-mail"
            "-w"
          ];
        };
        vdirsyncer = {
          enable = true;
          conflictResolution = "local wins";
        };
        khard = {
          enable = true;
        };
      };
    };

    calendar = {
      basePath = ".calendar";
      accounts.posteo = {
        local = {
          type = "filesystem";
        };
        remote = {
          userName = "marcwenzlawski@posteo.com";
          url = "https://posteo.de:8443/calendars/marcwenzlawski/default";
          type = "caldav";
          passwordCommand = [
            "security"
            "find-generic-password"
            "-s"
            "posteo-mail"
            "-w"
          ];
        };
        vdirsyncer = {
          enable = true;
          conflictResolution = "local wins";
        };
        khal = {
          enable = true;
        };
      };
    };
  };

  home.file = {
    "functions" = {
      target = ".config/fish/functions";
      source = ./dotfiles/fish/functions;
    };
    "vfish" = {
      target = ".config/fish/conf.d/vfish.fish";
      source = ./dotfiles/fish/conf.d/vfish.fish;
    };
    "abbr" = {
      target = ".config/fish/conf.d/abbr.fish";
      source = ./dotfiles/fish/conf.d/abbr.fish;
    };
    # "direnv" = {
    #   target = ".config/fish/completions/direnv.fish";
    #   source = ./dotfiles/fish/completions/direnv.fish;
    # };
    "mtmr" = {
      target = ".config/mtmr";
      source = ./dotfiles/mtmr;
    };
    "espanso-config" = {
      target = ".config/espanso/config/default.yml";
      source = ./dotfiles/espanso/config/default.yml;
    };
    "espanso-match-base" = {
      target = ".config/espanso/match/base.yml";
      source = ./dotfiles/espanso/match/base.yml;
    };
    "espanso-match-english" = {
      target = ".config/espanso/match/english.yml";
      source = ./dotfiles/espanso/match/english.yml;
    };
    "karabiner" = {
      target = ".config/karabiner";
      source = ./dotfiles/karabiner;
    };
    "direnvrc" = {
      target = ".config/direnv/direnvrc";
      source = ./dotfiles/direnvrc;
    };
    "colemak" = {
      target = "Library/Keyboard Layouts/Colemak_DH.bundle";
      source = ./dotfiles/Colemak_DH.bundle;
    };
    "defaultkeybinding" = {
      target = "Library/KeyBindings/DefaultKeyBinding.dict";
      source = ./dotfiles/DefaultKeyBinding.dict;
    };
    "raycast-scripts" = {
      target = ".config/raycast/scripts";
      source = ./dotfiles/raycast;
    };
    "share-pandoc" = {
      target = ".local/share/pandoc";
      source = ./share/pandoc;
    };
    "share-lua" = {
      target = ".local/share/lua";
      source = ./share/lua;
    };
    "scripts" = {
      target = ".local/bin";
      source = ./scripts;
      executable = true;
      recursive = true;
    };
    # "yabairc" = {
    #   target = ".config/yabai/yabairc";
    #   source = ./dotfiles/yabairc;
    # };
    # "skhdrc" = {
    #   target = ".config/skhd/skhdrc";
    #   source = ./dotfiles/skhdrc;
    # };
  };

  # programs.zsh.enableCompletion = true;
  # programs.zsh.enableAutosuggestions = true;
  # programs.zsh.enableSyntaxHighlighting = true;
  # programs.zsh.shellAliases = {
  #   ls = "ls --color=auto -F";
  #   nixswitch = "darwin-rebuild switch --flake ~/src/system-config/.#";
  #   nixup = "pushd ~/src/system-config; nix flake update; nixswitch; popd";
  # };
  # programs.starship.enable = true;
  # programs.starship.enableZshIntegration = true;

  # home.file.".inputrc".source = ./dotfiles/inputrc;
}
