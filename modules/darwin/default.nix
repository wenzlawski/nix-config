{
  agenix,
  pkgs,
  ...
}: {
  # here go the darwin preferences and config items
  imports = [./secrets.nix agenix.darwinModules.default];
  users.users.mw.home = "/Users/mw";
  programs.fish.enable = true;
  users.users.mw.shell = pkgs.fish;
  environment = {
    shells = with pkgs; [bash zsh fish];
    loginShell = pkgs.fish;
    systemPackages = [pkgs.coreutils agenix.packages.x86_64-darwin.default];
    systemPath = ["/usr/local/bin"];
    pathsToLink = ["/Applications"];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToEscape = true;
  fonts.fontDir.enable = true; # DANGER
  fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
  services.nix-daemon.enable = true;
  system.startup.chime = false;
  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain."com.apple.trackpad.scaling" = 1.5;
    trackpad.FirstClickThreshold = 0;
    trackpad.SecondClickThreshold = 0;
    dock = {
      orientation = "right";
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.4;
      expose-animation-duration = 0.5;
      persistent-apps = null;
      show-recents = false;
      static-only = true;
      tilesize = 48;
    };
    CustomUserPreferences = {
      "com.apple.screencapture" = {
        location = "~/Documents/screenshots";
        type = "png";
      };
      # to apply changes run
      # /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
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
    masApps = {};
    casks = [
      "librewolf"
      "freeplane"
      "calibre"
      "dropbox"
      "zotero@beta"
      "qlmarkdown"
      "qlcolorcode"
      "qlstephen"
      "notunes"
      "mtmr"
      "linearmouse"
      "hammerspoon"
      "dozer"
      "bruno"
      "spotify"
      "espanso"
    ];
    taps = [];
    brews = [];
  };
}
