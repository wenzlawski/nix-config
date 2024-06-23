{
  agenix,
  pkgs,
  ...
}: {
  # here go the darwin preferences and config items
  imports = [./secrets.nix agenix.darwinModules.default];
  users.users.mw.home = "/Users/mw";
  programs.zsh.enable = true;
  programs.fish.enable = true;
  users.users.mw.shell = pkgs.zsh;
  environment = {
    shells = with pkgs; [bash zsh fish];
    loginShell = pkgs.zsh;
    systemPackages = [pkgs.coreutils agenix.packages.x86_64-darwin.default];
    systemPath = ["/usr/local/bin"];
    pathsToLink = ["/Applications"];
    variables = {};
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToEscape = true;
  fonts.packages = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
  # security.sudo.extraConfig = ''
  #   mw ALL=(root) NOPASSWD: sha256:1042a454424c6255dfa89286fe0bde05a2416887bda6dad7e84f615ba2e8a499 /usr/local/bin/yabai --load-sa
  # '';
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
      AppleInterfaceStyleSwitchesAutomatically = true;
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
  # backwards compat; don't change
  system.stateVersion = 4;

  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        ctrl - up: yabai -m window --focus $(yabai -m query --windows --space | jq '.[].id' | sed -n '2p')
        ctrl - right : yabai -m space --focus next
        ctrl - left : yabai -m space --focus prev
        ctrl - down: yabai -m space --focus recent
      '';
    };

    yabai = {
      enable = true;
      enableScriptingAddition = true;
      config = {
        external_bar = "off:40:0";
        menubar_opacity = 1.0;
        mouse_follows_focus = "off";
        focus_follows_mouse = "off";
        display_arrangement_order = "default";
        window_origin_display = "default";
        window_placement = "second_child";
        window_zoom_persist = "on";
        window_shadow = "on";
        window_animation_duration = 0.0;
        window_animation_easing = "ease_out_circ";
        window_opacity_duration = 0.0;
        active_window_opacity = 1.0;
        normal_window_opacity = 0.9;
        window_opacity = "off";
        insert_feedback_color = "0xffd75f5f";
        split_ratio = 0.5;
        split_type = "auto";
        auto_balance = "off";
        top_padding = 0;
        bottom_padding = 0;
        left_padding = 0;
        right_padding = 0;
        window_gap = 2;
        layout = "float";
        mouse_modifier = "fn";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
      };
      extraConfig = "\n";
    };
  };

  launchd.user.agents = {
    notmuch.serviceConfig = {
      Label = "mw.notmuch-email";
      ProgramArguments = [
        "/etc/profiles/per-user/mw/bin/notmuch"
        "new"
      ];
      StandardErrorPath = "/tmp/notmuch_mw.err.log";
      StandardOutPath = "/tmp/notmuch_mw.out.log";
      RunAtLoad = true;
      StartCalendarInterval = [
        {
          Minute = 5;
        }
      ];
    };
    borg.serviceConfig = {
      Label = "mw.borgbackup-remote";
      ProgramArguments = ["$HOME/.local/bin/borg_backup.sh"];
      StandardErrorPath = "/tmp/borg_mw.err.log";
      StandardOutPath = "/tmp/borg_mw.out.log";
      RunAtLoad = true;
      StartCalendarInterval = [
        {
          Hour = 23;
          Minute = 59;
        }
      ];
    };
  };

  homebrew = {
    enable = false;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {
      QuickShade = 931571202;
      Image2icon = 992115977;
    };
    casks = [
      "betterdisplay"
      "bitwarden"
      "bruno"
      "calibre"
      "dropbox"
      "espanso"
      "finestructure/hummingbird/hummingbird"
      "font-eb-garamond"
      "font-et-book"
      "font-fira-code"
      "font-hack"
      "font-ia-writer-duo"
      "font-ia-writer-mono"
      "font-ia-writer-quattro"
      "font-input"
      "font-iosevka"
      "font-iosevka-nerd-font"
      "font-iosevka-term-nerd-font"
      "font-jetbrains-mono"
      "font-open-sans"
      "font-source-code-pro"
      "freeplane"
      "hammerspoon"
      "hiddenbar"
      "librewolf"
      "linearmouse"
      "logi-options-plus"
      "monitorcontrol"
      "mtmr"
      "notunes"
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "spotify"
      "zotero@beta"
      "macfuse"
      # "vmware-fusion" # download fails
    ];
    taps = ["homebrew/cask-fonts" "d12frosted/emacs-plus"];
    brews = [
      {
        name = "d12frosted/emacs-plus@30";
        args = [
          "--with-dbus"
          "--with-mailutils"
          "--with-no-frame-refocus"
          "--with-xwidgets"
          "--with-native-comp"
          "--with-poll"
          "--with-modern-black-gnu-head-icon"
        ];
      }
      "borgbackup/tap/borgbackup-fuse"
    ];
  };
}
