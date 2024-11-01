{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) lists strings;

  floating-apps = [
    # "System Settings"
    #    "Zoom"
    #    "zoom.us"
  ];

  floating-rules = lists.forEach floating-apps (name: "yabai -m rule --add app='${name}' manage=off");
  floating-rules-str = strings.concatStringsSep "\n" floating-rules;
in {
  services.yabai = {
    enable = true;

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

    extraConfig =
      floating-rules-str
      + "\n"
      + ''
        yabai -m config layout float
      '';
  };

  services.skhd = let
    hyper = "cmd + ctrl + alt";
    yabai = "${pkgs.yabai}/bin/yabai";
  in {
    enable = true;

    skhdConfig = ''
      # sleep when "F13" key is pressed (mapped to scroll lock via karabiner)
      f13 : pmset displaysleepnow

      # make floating window fill screen
      ctrl + alt - return : yabai -m window --grid 1:1:0:0:1:1

      # make floating window fill left-half of screen
      ctrl + alt - left   : yabai -m window --grid 1:2:0:0:1:1
      ctrl + alt - right  : yabai -m window --grid 1:2:1:0:1:1
      ctrl + alt + cmd - return : yabai -m window --toggle native-fullscreen

      ctrl - up: ${yabai} -m window --focus $(${yabai} -m query --windows --space | jq '.[].id' | sed -n '2p')
      ctrl - right: ${yabai} -m space --focus next
      ctrl - left: ${yabai} -m space --focus prev
      ctrl - down: ${yabai} -m space --focus recent
      cmd + alt - space: emacsclient -ne "(my/make-capture-frame)"
      ${hyper} - space: emacsclient -ne "(my/focus-or-make-ai-frame)"
    '';
  };

  environment.systemPackages = [pkgs.skhd];
}
