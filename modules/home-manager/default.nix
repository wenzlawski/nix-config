{
  pkgs,
  lib,
  ...
}: {
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";

  # specify my home-manager configs
  home.packages = with pkgs; [
    # bruno # build fails
    # calibre # broken?
    alejandra
    alt-tab-macos
    anki-bin
    bash
    bitwarden-cli
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
    gnugrep
    gnumake
    gnupg
    gnuplot
    graphviz
    hledger
    httpie
    iina
    imagemagick
    jq
    ledger
    less
    libreoffice-bin
    msmtp
    neovim
    net-news-wire
    ninja
    nixfmt-classic
    nixpkgs-fmt
    notmuch
    pandoc
    raycast
    ripgrep
    ripgrep-all
    spicetify-cli
    tmux
    transmission
    tre-command
    tree
    w3m
    wget
    yt-dlp
    zellij
    zoxide
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "emacs";
  };
  editorconfig.enable = true;
  programs = {
    eza.enable = true;
    git = {
      userEmail = "marc.wenzlawski@outlook.de";
      userName = "Marc Wenzlawski";
    };
    zsh.enable = true;
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
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        set pure_enable_nixdevshell true
      '';
      loginShellInit = ''
      '';
      shellAliases = lib.mkForce {};
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          name = "tide";
          src = pkgs.fishPlugins.tide.src;
        }
      ];
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
    "items" = {
      target = "Library/Application Support/MTMR/items.json";
      source = ./dotfiles/mtmr.json;
    };
    "espanso" = {
      target = ".config/espanso";
      source = ./dotfiles/espanso;
    };
    "karabiner" = {
      target = ".config/karabiner";
      source = ./dotfiles/karabiner;
    };
    "direnvrc" = {
      target = ".config/direnv/direnvrc";
      source = ./dotfiles/direnvrc;
    };
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
