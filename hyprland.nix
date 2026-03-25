{ hyprMainMod ? "SUPER", ... }:

{
  home.file = {
    ".config/hypr/scripts/app-volume.sh" = {
      source = ./hypr-scripts/app-volume.sh;
      executable = true;
    };
    ".config/hypr/scripts/main-watchers.sh" = {
      source = ./hypr-scripts/main-watchers.sh;
      executable = true;
    };
    ".config/hypr/scripts/output-device.sh" = {
      source = ./hypr-scripts/output-device.sh;
      executable = true;
    };
    ".config/hypr/scripts/toggle_layout.sh" = {
      source = ./hypr-scripts/toggle_layout.sh;
      executable = true;
    };
    ".config/hypr/scripts/toggle_resolution.sh" = {
      source = ./hypr-scripts/toggle_resolution.sh;
      executable = true;
    };

    ".config/hypr/scripts/enforcer/enforce-overwatch-fullscreen.sh" = {
      source = ./hypr-scripts/enforcer/enforce-overwatch-fullscreen.sh;
      executable = true;
    };
    ".config/hypr/scripts/enforcer/enforce-special.sh" = {
      source = ./hypr-scripts/enforcer/enforce-special.sh;
      executable = true;
    };
    ".config/hypr/scripts/enforcer/enforce-workspace-by-class.sh" = {
      source = ./hypr-scripts/enforcer/enforce-workspace-by-class.sh;
      executable = true;
    };
    ".config/hypr/scripts/enforcer/enforce-workspace9.sh" = {
      source = ./hypr-scripts/enforcer/enforce-workspace9.sh;
      executable = true;
    };
    ".config/hypr/scripts/enforcer/list-clients.sh" = {
      source = ./hypr-scripts/enforcer/list-clients.sh;
      executable = true;
    };

    # toggle_layout.sh persists orientation in this file.
    ".config/hypr/layout.conf".text = ''
      master {
        orientation                   = center
        mfact                         = 0.40
        slave_count_for_center_master = 0
      }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "yazi";
      "$menu" = "ags request toggle-launcher";
      "$mainMod" = hyprMainMod;

      monitor = [
        "DP-3, 5120x1440@240, 0x0, 1, bitdepth, 10"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "XDG_MENU_PREFIX,arch-"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      "exec-once" = [
        "eww daemon"
        "~/.config/ags/app"
        "wpaperd"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
        "openrazer-daemon.service"
        "[workspace special:magic] feishin"
        "[workspace 9] ntfyDesktop"
        "kdeconnectd"
        "kdeconnect-indicator"
        "~/.config/hypr/scripts/main-watchers.sh"
      ];

      general = {
        layout = "master";
        gaps_in = 5;
        gaps_out = 8;
        border_size = 3;
        "col.active_border" = "rgba(bd93f988) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = true;
      };

      master = {
        orientation = "center";
        mfact = 0.40;
        slave_count_for_center_master = 0;
      };

      input = {
        kb_layout = "us,de";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0.0;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = false;
        };
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = 1;
        bezier = [
          "default, 0.05, 0.9, 0.1, 1.05"
          "wind, 0.05, 0.9, 0.1, 1.05"
          "overshot, 0.13, 0.99, 0.29, 1.08"
          "liner, 1, 1, 1, 1"
          "bounce, 0.4, 0.9, 0.6, 1.0"
          "snappyReturn, 0.4, 0.9, 0.6, 1.0"
          "slideInFromRight, 0.5, 0.0, 0.5, 1.0"
        ];
        animation = [
          "windows, 1, 5, snappyReturn, slidevert"
          "windowsIn, 1, 5, snappyReturn, slidevert right"
          "windowsOut, 1, 5, snappyReturn, slide"
          "windowsMove, 1, 6, bounce, slide"
          "fadeIn, 1, 10, default"
          "fadeOut, 1, 10, default"
          "fadeSwitch, 1, 10, default"
          "fadeShadow, 1, 10, default"
          "fadeDim, 1, 10, default"
          "fadeLayers, 1, 10, default"
          "workspaces, 1, 2, liner, slidevert"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
        ];
      };

      bind = [
        "$mainMod, Q, killactive,"
        "$mainMod, P, pseudo,"
        "$mainMod, BACKSPACE, exec, ags request toggle-power-menu"
        "$mainMod CTRL, BACKSPACE, exec, hyprlock"
        "$mainMod ALT, K, exec, hyprctl switchxkblayout all next"
        "$mainMod, F1, exec, ~/.config/hypr/gamemode.sh"

        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        "$mainMod, F11, fullscreen, 0"
        "$mainMod CTRL, F11, fullscreen, 1"
        "$mainMod, F, togglefloating"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod, M, workspace, -1"
        "$mainMod, code:61, workspace, +1"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT, M, movetoworkspace, -1"
        "$mainMod SHIFT, code:61, movetoworkspace, +1"

        "$mainMod CTRL, 1, movetoworkspacesilent, 1"
        "$mainMod CTRL, 2, movetoworkspacesilent, 2"
        "$mainMod CTRL, 3, movetoworkspacesilent, 3"
        "$mainMod CTRL, 4, movetoworkspacesilent, 4"
        "$mainMod CTRL, 5, movetoworkspacesilent, 5"
        "$mainMod CTRL, 6, movetoworkspacesilent, 6"
        "$mainMod CTRL, 7, movetoworkspacesilent, 7"
        "$mainMod CTRL, 8, movetoworkspacesilent, 8"
        "$mainMod CTRL, 9, movetoworkspacesilent, 9"
        "$mainMod CTRL, 0, movetoworkspacesilent, 10"

        "$mainMod, SPACE, exec, $menu"
        "$mainMod, return, exec, $terminal"
        "$mainMod CTRL, W, exec, $terminal impala"
        "$mainMod CTRL, B, exec, $terminal bluetui"
        "$mainMod CTRL, A, exec, $terminal ncpamixer"
        "$mainMod CTRL, E, exec, $terminal yazi"
        "$mainMod CTRL, S, exec, $terminal nudoku"
        "$mainMod CTRL, D, exec, $terminal dua i"
        "$mainMod CTRL, G, exec, $terminal amdgpu_top --dark"
        "$mainMod CTRL SHIFT, D, exec, $terminal dua i /"
        "$mainMod SHIFT, E, exec, dolphin"
        "$mainMod, C, exec, code"
        "$mainMod, G, exec, google-chrome-stable"

        "$mainMod, code:34, layoutmsg, focusmaster master"
        "$mainMod, P, layoutmsg, cyclenext"
        "$mainMod, U, layoutmsg, cycleprev"
        "$mainMod SHIFT, code:34, layoutmsg, swapwithmaster master"
        "$mainMod SHIFT, P, layoutmsg, swapnext"
        "$mainMod SHIFT, U, layoutmsg, swapprev"
        "$mainMod, Tab, exec, ~/.config/hypr/scripts/toggle_layout.sh"
        "$mainMod CTRL, Tab, exec, ~/.config/hypr/scripts/toggle_resolution.sh"

        "$mainMod ALT, 1, exec, hyprshot --freeze -m window -o ~/Pictures/Screenshots"
        "$mainMod ALT, 2, exec, hyprshot --freeze -m region -o ~/Pictures/Screenshots"
        "$mainMod ALT, 0, exec, hyprpicker -a"
      ];

      binde = [
        "$mainMod ALT, h, resizeactive, -25 0"
        "$mainMod ALT, j, resizeactive, 0 25"
        "$mainMod ALT, k, resizeactive, 0 -25"
        "$mainMod ALT, l, resizeactive, 25 0"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "SHIFT,XF86AudioRaiseVolume, exec, ~/.config/hypr/scripts/app-volume.sh up"
        "SHIFT,XF86AudioLowerVolume, exec, ~/.config/hypr/scripts/app-volume.sh down"
        "SHIFT,XF86AudioMute, exec, ~/.config/hypr/scripts/app-volume.sh mute"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        "SHIFT,XF86AudioNext, exec, ~/.config/hypr/scripts/output-device.sh next"
        "SHIFT,XF86AudioPrev, exec, ~/.config/hypr/scripts/output-device.sh prev"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrulev2 = [
        "float,title:^(Sign in to Steam|Discord Updater)$"
        "opacity 0.45,title:^(Sign in to Steam|Discord Updater)$"
        "move 100%-w-16 100%-h-16,title:^(Sign in to Steam|Discord Updater)$"

        "opacity 0.95,class:^(steam)$"
        "workspace 9,class:^(steam)$"

        "opacity 0.95,class:^(discord)$"
        "workspace special:magic,class:^(discord)$"

        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "opacity 0.0,class:^(xwaylandvideobridge)$"
      ];
    };
  };
}
