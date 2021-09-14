# nix home manager config for macOS

{ pkgs, ... }:

{

  home.file.".emacs.d/init.el" = {
    source = /home/matt/dotfiles/config/emacs.d/init.el;
  };

  home.sessionVariables = {
    SPACESHIP_VI_MODE_SHOW = false;
    SPACESHIP_USER_SHOW = "always";
    SPACESHIP_HOST_SHOW = "always";
    SPACESHIP_PROMPT_ADD_NEWLINE = false;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      italic-text = "always";
      style = "full";
      map-syntax = [ ".eslintignore:Git Ignore" ".prettierignore:Git Ignore" ".prettierrc:JSON" ];
    };
    themes = {
      dracula = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "sublime"; # Bat uses sublime syntax for its themes
        rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
        sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
      } + "/Dracula.tmTheme");
    };
  };

  programs.git = {
    enable = true;
    userName = "sciencefidelity";
    userEmail = "32623301+sciencefidelity@users.noreply.github.com";

    signing = {
      key = "9F071448877E6705";
      signByDefault = true;
    };

    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
      type = "cat-file -t";
      dump = "cat-file -p";
    };
  };

  programs.emacs = {
    enable = true;
  };

  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };

  programs.git = {
    enable = true;

    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
      type = "cat-file -t";
      dump = "cat-file -p";
    };

    delta.enable = true;

    extraConfig = { init = { defaultBranch = "main"; } ; };

    signing = {
      key = "FF3B11AF2EB4CA29";
      signByDefault = true;
    };

    userName = "sciencefidelity";
    userEmail = "32623301+sciencefidelity@users.noreply.github.com";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  programs.htop = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraConfig = ''
      lua << EOF
      ${builtins.readFile /home/matt/dotfiles/config/nvim/init.lua}
      EOF
    '';
    withNodeJs = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 20;
    extraConfig = ''
      set-option -ga terminal-overrides ",xterm-24bits:Tc"

      # unbind default prefix and set it to Ctrl+s
      set -g prefix C-s
      unbind C-b
      bind C-s send-prefix

      # speed up escape in nvim
      set -g base-index 1

      # custom key bindings
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      bind-key t set-option status

      # status bar options
      set -g status-bg "#282a36"
      set -g status-fg "#ff79c6"

      set-option -g status-right ""
      set-option -ag status-right " #[fg="#f1fa8c",bg=default]#(zsh ~/dotfiles/config/zsh/cpu.sh) "
      set-option -ag status-right " #[fg="#8be9fd",bg=default]#(free -h | awk '/^Mem/ {print $3}')/#(free -h | awk '/^Mem/ {print $2}') "
      set-option -ag status-right " #[fg="#50fa7b",bg=default]#(zsh ~/dotfiles/config/zsh/temp.sh) "
      set-option -ag status-right " #[fg="#ff79c6",bg=default]#(date +"%R") "
    '';
    keyMode = "vi";
    newSession = true;
    terminal = "xterm-24bits";
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    # defaultKeymap = "vicmd"; # prints a list of keymappings when starting shell
    # dotDir = ".config/zsh";
    history = {
      save = 1000;
      size = 1000;
    };

    initExtra = ''
      # Basic auto/tab complete
      _comp_options+=(globdots)

      # vi mode
      bindkey -v
      export KEYTIMEOUT=1

      # Use vim keys in tab complete menu
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history
      bindkey -v '^?' backward-delete-char

      # Use lf to switch directories and bind it to ctrl-o
      lfcd () {
          tmp="$(mktemp)"
          lf -last-dir-path="$tmp" "$@"
          if [ -f "$tmp" ]; then
              dir="$(cat "$tmp")"
              rm -f "$tmp"
              [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
          fi
      }
      bindkey -s '^o' 'lfcd\n'

      # Edit line in vim with ctrl-e
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line

      bindkey '^ ' autosuggest-accept

      export BAT_THEME="Dracula"

      alias ..="cd .."
      alias ...="cd ../.."
      alias ....="cd ../../.."
      alias .....="cd ../../../.."

      eval "$(ssh-agent -s)" > /dev/null
      ssh-add ~/.ssh/github 2> /dev/null
      export GPG_TTY=$(tty)
      gitpush() {
        pull
        git add .
        git commit -m "$*"
        git push
      }
      gitupdate() {
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/github
        ssh -T git@github.com
      }
      alias gp=gitpush
      alias gu=gitupdate

      # archive extractor - usage: ext <file>
      ext ()
      {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2) tar xjf $1;;
            *.tar.gz) tar xzf $1;;
            *.tar.xz) tar xJf $1;;
            *.bz2) bunzip2 $1;;
            *.rar) unrar x $1;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1;;
            *.tgz) tar xzf $1;;
            *.zip) unzip $1;;
            *.Z) uncompress $1;;
            *.7z) 7z x $1;;
            *) echo "'$1' cannot be extracted via ex()";;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
    '';

    initExtraBeforeCompInit = ''
      zstyle ':completion:*' menu select
      zmodload zsh/complist
    '';

    initExtraFirst = ''
      if [[ "$TERM" == "xterm-256color" ]]; then
          export TERM=xterm-24bits
      fi
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "spaceship-prompt/spaceship-prompt"; tags = [ use:spaceship.zsh from:github as:theme ]; }
      ];
    };
  };
}