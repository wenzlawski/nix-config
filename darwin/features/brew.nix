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
      "colemak-dh"
      "colemak-dhk"
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
      "librewolf"
      "linearmouse"
      "logi-options-plus"
      "monitorcontrol"
      "mtmr"
      "notunes"
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "raycast"
      "spotify"
      "terminal-notifier"
      "zotero@beta"
      "macfuse"
      "dutis"
      "activitywatch"
      # "vmware-fusion" # download fails
    ];
    taps = ["homebrew/cask-fonts"];
    brews = [
      "borgbackup/tap/borgbackup-fuse"
      "tsonglew/dutis"
    ];
  };
}
