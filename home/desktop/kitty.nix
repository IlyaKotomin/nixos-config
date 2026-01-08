{ config, lib, pkgs, ... }:

{
  # Kitty terminal emulator
  programs.kitty = {
    enable = true;
    
    settings = {
      # Font
      font_family = "JetBrains Mono";
      font_size = 12;
      
      # Window
      window_padding_width = 8;
      hide_window_decorations = false;
      confirm_os_window_close = 0;
      
      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      
      # Scrollback
      scrollback_lines = 10000;
      
      # Bell
      enable_audio_bell = false;
      visual_bell_duration = "0.0";
      
      # URLs
      url_style = "curly";
      
      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };

    # Keybindings
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+plus" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";
    };
  };
}
