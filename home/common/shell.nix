{ config, lib, pkgs, ... }:

{
  # Bash configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    shellAliases = {
      # List aliases
      ll = "eza -la --icons";
      ls = "eza --icons";
      la = "eza -a --icons";
      lt = "eza --tree --icons";
      
      # NixOS rebuild shortcuts
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config";
      nrt = "sudo nixos-rebuild test --flake ~/nixos-config";
      nrb = "sudo nixos-rebuild boot --flake ~/nixos-config";
      
      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Safety
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      
      # Utilities
      cat = "bat";
      grep = "grep --color=auto";
    };

    initExtra = ''
      # FZF integration
      if command -v fzf &> /dev/null; then
        eval "$(fzf --bash)"
      fi

      # Direnv hook
      if command -v direnv &> /dev/null; then
        eval "$(direnv hook bash)"
      fi
    '';

    bashrcExtra = ''
      # Custom prompt
      export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    '';
  };

  # Starship prompt (optional - enable if you want a modern prompt)
  programs.starship = {
    enable = false;  # Set to true to enable
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 5;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = " ";
      };
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  # Direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # FZF fuzzy finder
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };
}
