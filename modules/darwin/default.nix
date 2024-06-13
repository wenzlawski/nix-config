{ agenix, pkgs, ... }: {
  # here go the darwin preferences and config items
  imports = [ ./secrets.nix agenix.darwinModules.default ];
  users.users.mw.home = "/Users/mw";
  programs.zsh.enable = true;
  programs.fish.enable = true;
  users.users.mw.shell = pkgs.zsh;
  environment = {
    shells = with pkgs; [ bash zsh fish ];
    loginShell = pkgs.zsh;
    systemPackages = [ pkgs.coreutils agenix.packages.x86_64-darwin.default ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
    variables = { };
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToEscape = true;
  fonts.fontDir.enable = true; # DANGER
  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  security.sudo.extraConfig = ''
    mw ALL=(root) NOPASSWD: sha256:1042a454424c6255dfa89286fe0bde05a2416887bda6dad7e84f615ba2e8a499 /usr/local/bin/yabai --load-sa
  '';
  services.nix-daemon.enable = true;
  system.startup.chime = false;
  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      _FXShowPosixPathInTitle = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv";
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
      "com.apple.trackpad.scaling" = 1.5;
      AppleEnableSwipeNavigateWithScrolls = true;
    };
    trackpad = {
      FirstClickThreshold = 0;
      SecondClickThreshold = 0;
      ActuationStrength = 0;
      Clicking = true;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.4;
      expose-animation-duration = 0.5;
      minimize-to-application = true;
      orientation = "right";
      persistent-apps = null;
      show-recents = false;
      static-only = true;
      tilesize = 12;
    };
    CustomUserPreferences = {
      "com.apple.screencapture" = {
        location = "~/Documents/screenshots";
        type = "png";
      };
      # to apply changes run
      # /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      # show current with
      # plutil -p ~/Library/Preferences/com.apple.symbolichotkeys.plist
      # https://gist.github.com/mkhl/455002#file-ctrl-f1-c-L12
      # https://web.archive.org/web/20130430100126/http://hintsforums.macworld.com/showthread.php?t=114785
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "36" = {
            # F11 - show desktop
            enabled = false;
          };
          "60" = {
            # C-Spc - prev input source
            enabled = false;
          };
          "61" = {
            # C-M-Spc - next input source
            enabled = false;
          };
          "64" = {
            # Cmd-Spc - Spotlight
            enabled = false;
          };
          "65" = {
            # Cmd-M-Spc - Show finder
            enabled = false;
          };
          "79" = {
            # C-Left - Space left
            enabled = true;
          };
          "81" = {
            # C-Right - Space right
            enabled = true;
          };
        };
      };
    };
  };
  # backwards compat; don't change
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {
      QuickShade = 931571202;
    };
    casks = [
      "bitwarden"
      "bruno"
      "calibre"
      "dozer"
      "dropbox"
      "espanso"
      "finestructure/hummingbird/hummingbird"
      "font-fira-code"
      "font-hack"
      "font-open-sans"
      "font-ia-writer-duo"
      "font-ia-writer-mono"
      "font-ia-writer-quattro"
      "font-input"
      "font-iosevka"
      "font-iosevka-nerd-font"
      "font-iosevka-term-nerd-font"
      "font-jetbrains-mono"
      "font-source-code-pro"
      "freeplane"
      "hammerspoon"
      "librewolf"
      "linearmouse"
      "logi-options-plus"
      "mtmr"
      "monitorcontrol"
      "notunes"
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "spotify"
      # "vmware-fusion" # download fails
      "zotero@beta"
    ];
    taps = [ "homebrew/cask-fonts" ];
    brews = [
      "koekeishiya/formulae/yabai"
      "koekeishiya/formulae/skhd"
    ];
  };
}
