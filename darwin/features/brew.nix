{
  pkgs,
  config,
  ...
}: {
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
      "font-dejavu-sans-mono-nerd-font"
      "font-go-mono-nerd-font"
      "font-gnu-unifont"
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
