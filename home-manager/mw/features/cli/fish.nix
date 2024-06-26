{
  config,
  pkgs,
  lib,
  system,
  inputs,
  ...
}: let
  inherit (lib.lists) optionals;
  inherit (lib.attrsets) optionalAttrs;
  inherit (pkgs.stdenv) isLinux isDarwin;
  # nix-colors-lib = inputs.nix-colors.lib-contrib {inherit pkgs;};
  # inherit (nix-colors-lib) shellThemeFromScheme;
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      eza
      starship
      nix-your-shell
      ;
  };

  programs.fish = {
    enable = true;

    shellAliases =
      {
        ls = "${pkgs.eza}/bin/eza";
        nix-search = "nix-env -qaP";
        http = "${pkgs.xh}/bin/xh";
        cdrr = "cd (git repo-root)";
        alejandra = "${pkgs.alejandra}/bin/alejandra -q";
      }
      // optionalAttrs isDarwin {
        idea = "open -an 'IntelliJ IDEA.app'";
      };

    functions = {
      # get the current nix store path for the given binary
      nix-which =
        if isDarwin
        then "readlink (which $argv[1])"
        else "readlink -e (which $argv[1])";

      # like nix-which, but stripping out the /bin/$program_name bit
      # useful for checking out other files in the same package
      nix-which-dir = "nix-which $argv[1] | sed -e 's/\\/bin\\/.*$//'";

      # shortcut to trick lazy brain into using `nix shell` instead of
      # `nix-shell -p`
      ns = "nix shell nixpkgs#{$argv}";

      drs = "darwin-rebuild switch --flake ~/.config/nix";

      vfo = "vterm_cmd find-file-other-window (realpath \"$argv\")";

      multicd = "echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
    };

    interactiveShellInit = ''
      # setup any-nix-shell integration
      # {pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      # If we're at a text console, load shell colors using a script
      # generated by the nix-colors module. Terminal emulators (alacritty, etc)
      # have their colors set elsewhere.
      # if [ "$TERM" = "linux" ]
      #   sh {shellThemeFromScheme {scheme = config.colorScheme;}}
      # end

      set fish_greeting # Disable greeting
      set pure_enable_nixdevshell true
      set -g NIX_BUILD_SHELL $SHELL
      set -g LUA_PATH "$HOME/.local/share/lua/?.lua;;"
      if command -q nix-your-shell
        nix-your-shell fish | source
      end
    '';

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
  };

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file = {
    "vfish" = {
      target = ".config/fish/conf.d/vfish.fish";
      source = ../../dotfiles/fish/conf.d/vfish.fish;
    };
    "abbr" = {
      target = ".config/fish/conf.d/abbr.fish";
      source = ../../dotfiles/fish/conf.d/abbr.fish;
    };
  };
}
