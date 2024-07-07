{
  pkgs,
  config,
  ...
}: {
  system.keyboard.enableKeyMapping = true;

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
      "com.apple.keyboard.fnState" = true;
      AppleEnableSwipeNavigateWithScrolls = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleFontSmoothing = 1;
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
      wvous-br-corner = 1;
    };
    CustomUserPreferences = {
      "com.apple.screencapture" = {
        location = "~/Documents/screenshots";
        type = "png";
      };
      "org.gnu.Emacs" = {
        AppleFontSmoothing = false;
        ApplePressAndHoldEnabled = "NO";
      };
      # to apply changes run
      # /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      # show current with
      # plutil -p ~/Library/Preferences/com.apple.symbolichotkeys.plist
      # https://gist.github.com/mkhl/455002#file-ctrl-f1-c-L12
      # https://web.archive.org/web/20130430100126/http://hintsforums.macworld.com/showthread.php?t=114785
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "8" = {
            # F3
            enabled = false;
          };
          "9" = {
            # F4
            enabled = false;
          };
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
            enabled = false;
          };
          "81" = {
            # C-Right - Space right
            enabled = false;
          };
          "83" = {
            # C-Down - Win show
            enabled = false;
          };
          "85" = {
            # C-Up - Space show
            enabled = false;
          };
        };
      };
    };
  };
}
