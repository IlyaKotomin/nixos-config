{ config, lib, pkgs, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    
    userName = "kotoxik";
    # userEmail = "your@email.com";  # TODO: Set your email
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      
      # Better diffs
      diff.colorMoved = "default";
      
      # Merge settings
      merge.conflictstyle = "diff3";
      
      # Credentials
      credential.helper = "store";
      
      # Core settings
      core = {
        autocrlf = "input";
      };
    };

    # Delta for better diffs (optional)
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = false;
        line-numbers = true;
      };
    };

    # Git aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      lg = "log --oneline --graph --decorate --all";
      amend = "commit --amend --no-edit";
    };

    # Ignore patterns
    ignores = [
      ".direnv"
      ".envrc"
      "*.swp"
      "*.swo"
      "*~"
      ".DS_Store"
      "Thumbs.db"
      ".idea/"
      ".vscode/"
      "*.log"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
      ".env"
      ".env.local"
    ];
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  # Lazygit TUI
  programs.lazygit = {
    enable = true;
  };
}
