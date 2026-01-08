{ config, lib, pkgs, ... }:

{
  # Development tools managed by Home Manager
  home.packages = with pkgs; [
    # SDKs and runtimes
    nodejs_22
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    
    # CLI tools for development
    jq              # JSON processor
    yq              # YAML processor
    httpie          # HTTP client
    
    # Database tools
    postgresql      # psql client
    
    # Cloud tools
    flyctl
  ];

  # VS Code configuration
  programs.vscode = {
    enable = true;
    
    # Extensions (you can add more)
    extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
      
      # General
      eamodio.gitlens
      usernamehw.errorlens
      
      # Themes
      pkief.material-icon-theme
    ];

    # User settings
    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";
      "editor.fontLigatures" = true;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.minimap.enabled" = false;
      "editor.wordWrap" = "on";
      "editor.bracketPairColorization.enabled" = true;
      
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;
      
      "terminal.integrated.fontSize" = 13;
      
      "workbench.iconTheme" = "material-icon-theme";
      
      # Nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      
      # Git
      "git.autofetch" = true;
      "git.confirmSync" = false;
    };
  };

  # Vim configuration
  programs.vim = {
    enable = true;
    defaultEditor = true;
    
    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      mouse = "a";
    };

    extraConfig = ''
      " Enable syntax highlighting
      syntax on
      
      " Search settings
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase
      
      " Visual settings
      set cursorline
      set showmatch
      set wildmenu
      
      " Backup settings
      set nobackup
      set nowritebackup
      set noswapfile
      
      " Allow backspace in insert mode
      set backspace=indent,eol,start
      
      " Status line
      set laststatus=2
    '';
  };

  # Btop system monitor
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      vim_keys = true;
    };
  };
}
