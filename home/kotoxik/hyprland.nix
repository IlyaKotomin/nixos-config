{ config, lib, pkgs, ... }:

{
  # Hyprland-specific configuration for Home Manager
  # This file contains user-level Hyprland configuration
  
  # Note: Enable this module if using Hyprland
  # wayland.windowManager.hyprland.enable = true;

  # Waybar configuration
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        
        modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "clock" "tray" ];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<tt>{calendar}</tt>";
        };
        
        cpu = {
          format = "  {usage}%";
          tooltip = false;
        };
        
        memory = {
          format = "  {}%";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
        
        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };
        
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = " ";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        
        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        border-bottom: 2px solid rgba(137, 180, 250, 0.5);
      }

      #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
        border-radius: 0;
      }

      #workspaces button.active {
        background-color: #89b4fa;
        color: #1e1e2e;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }
    '';
  };

  # Dunst notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 100;
        offset = "10x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#89b4fa";
        font = "JetBrains Mono 10";
        corner_radius = 8;
      };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 5;
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#f38ba8";
        foreground = "#1e1e2e";
        timeout = 0;
      };
    };
  };

  # Rofi application launcher
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "breeze-dark";
      terminal = "kitty";
      drun-display-format = "{name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Window";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#1e1e2e";
        fg = mkLiteral "#cdd6f4";
        accent = mkLiteral "#89b4fa";
      };
      
      window = {
        width = mkLiteral "600px";
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "8px";
      };
      
      mainbox = {
        background-color = mkLiteral "transparent";
      };
      
      inputbar = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        padding = mkLiteral "10px";
      };
      
      listview = {
        background-color = mkLiteral "transparent";
        lines = 8;
        padding = mkLiteral "10px";
      };
      
      element = {
        padding = mkLiteral "8px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
      };
      
      "element selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@bg";
        border-radius = mkLiteral "4px";
      };
    };
  };

  # Hyprland configuration file
  xdg.configFile."hypr/hyprland.conf".text = ''
    # Monitor configuration
    monitor=,preferred,auto,auto

    # Execute at launch
    exec-once = waybar
    exec-once = dunst
    exec-once = swww init

    # Input
    input {
      kb_layout = us
      follow_mouse = 1
      sensitivity = 0
      touchpad {
        natural_scroll = true
      }
    }

    # General
    general {
      gaps_in = 5
      gaps_out = 10
      border_size = 2
      col.active_border = rgba(89b4faee)
      col.inactive_border = rgba(595959aa)
      layout = dwindle
    }

    # Decoration
    decoration {
      rounding = 8
      blur {
        enabled = true
        size = 3
        passes = 1
      }
      shadow {
        enabled = true
        range = 4
        render_power = 3
        color = rgba(1a1a1aee)
      }
    }

    # Animations
    animations {
      enabled = true
      bezier = myBezier, 0.05, 0.9, 0.1, 1.05
      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 7, default, popin 80%
      animation = fade, 1, 7, default
      animation = workspaces, 1, 6, default
    }

    # Layouts
    dwindle {
      pseudotile = true
      preserve_split = true
    }

    # Key bindings
    $mainMod = SUPER

    bind = $mainMod, Return, exec, kitty
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, dolphin
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, D, exec, rofi -show drun
    bind = $mainMod, P, pseudo,
    bind = $mainMod, J, togglesplit,

    # Move focus
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Switch workspaces
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move window to workspace
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Mouse bindings
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # Screenshot
    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
    bind = SHIFT, Print, exec, grim - | wl-copy

    # Volume
    bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    # Brightness
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
  '';
}
