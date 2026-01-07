{ config, lib, pkgs, ... }:

{
  # Desktop application configurations

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

  # GTK theme configuration
  gtk = {
    enable = true;
    
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };

    font = {
      name = "Noto Sans";
      size = 10;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt theme configuration (for consistency with KDE)
  qt = {
    enable = true;
    platformTheme.name = "kde";
  };

  # XDG user directories
  xdg = {
    enable = true;
    
    userDirs = {
      enable = true;
      createDirectories = true;
      
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };

    # MIME type associations
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "image/png" = "org.kde.gwenview.desktop";
        "image/jpeg" = "org.kde.gwenview.desktop";
        "video/mp4" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
      };
    };
  };

  # Fonts
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    # Fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    
    # Additional desktop tools
    vlc
    kdePackages.gwenview   # Image viewer
    kdePackages.okular     # Document viewer
  ];
}
