{ pkgs, lib, ... }: {
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";

  # specify my home-manager configs
  home.packages = with pkgs; [
    # bruno # build fails
    # calibre # broken?
    notmuch
    alejandra
    alt-tab-macos
    anki-bin
    bitwarden-cli
    bottom
    broot
    cmake
    coreutils-prefixed
    curl
    disk-inventory-x
    dust
    duti
    groff
    eza
    fd
    findutils
    gawk
    gnugrep
    gnumake
    gnupg
    gnuplot
    graphviz
    hledger
    httpie
    iina
    imagemagick
    isync
    jq
    ledger
    less
    libreoffice-bin
    neovim
    net-news-wire
    ninja
    nixfmt-classic
    nixpkgs-fmt
    raycast
    ripgrep
    ripgrep-all
    spicetify-cli
    tmux
    transmission
    tre-command
    ghostscript
    tree
    w3m
    wget
    yt-dlp
    just
    zellij
    zoxide
    nix-your-shell
    nodePackages.prettier
    pdftk
    poppler_utils
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "emacs";
  };
  editorconfig.enable = true;
  programs = {
    bash.enable = true;
    zsh.enable = true;

    eza.enable = true;
    git = {
      enable = true;
      userEmail = "marc.wenzlawski@outlook.de";
      userName = "Marc Wenzlawski";
      ignores = [ ".DS_Store" ];
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
      config = { hide_env_diff = true; };
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
      shellAliases = lib.mkForce { alejandra = "alejandra -q"; };
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
      defaults = { pdf-engine = "xelatex"; };
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
        inherit (tpkgs)
          scheme-small soul lualatex-math selnolig collection-fontsrecommended
          latex-fonts courier;
      };
    };

    notmuch = {
      enable = true;
      hooks.preNew = "/etc/profiles/per-user/mw/bin/mbsync -a";
    };

    mbsync.enable = true;
    msmtp.enable = true;
  };
  accounts.email = {
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
        tls = { enable = true; };
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
      passwordCommand =
        "security find-generic-password -s mbsync-icloud-password -w";
    };

    accounts.posteo = {
      address = "marcwenzlawski@posteo.com";
      realName = "Marc Wenzlawski";
      userName = "marcwenzlawski@posteo.com";
      imap = {
        host = "posteo.de";
        port = 993;
      };
      smtp = { host = "posteo.de"; };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      passwordCommand =
        "security find-generic-password -s mbsync-posteo-password -w";
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
