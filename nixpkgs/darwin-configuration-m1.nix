{ config, lib, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  environment = {
    shells = [ pkgs.zsh ];
    systemPackages = with pkgs; [
      bat
      coreutils
      curl
      exa
      fd
      gnupg
      home-manager
      lf
      pinentry
      ripgrep
      starship
      wget
      zsh-autosuggestions
      zsh-syntax-highlighting
    ];
  };

  home-manager.backupFileExtension = "bak";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.matt = { config, lib, pkgs, ... }: {
    home.stateVersion = "22.05";

    home.sessionVariables = {
      EDITOR = "vim";
      VISUAL = "$EDITOR";
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

      aliases = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
        hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
        type = "cat-file -t";
        dump = "cat-file -p";
      };

      extraConfig = {
        init = { defaultBranch = "main"; } ;
        pull = { rebase = false; } ;
      };

      userName = "sciencefidelity";
      userEmail = "32623301+sciencefidelity@users.noreply.github.com";
    };

    programs.home-manager.enable = true;

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;

        format = lib.concatStrings [
          "$username"
          "$shlvl"
          "$singularity"
          "$kubernetes"
          "$directory"
          "$hostname"
          "$vcsh"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$docker_context"
          "$package"
          "$cmake"
          "$cobol"
          "$dart"
          "$deno"
          "$dotnet"
          "$elixir"
          "$elm"
          "$erlang"
          "$golang"
          "$helm"
          "$java"
          "$julia"
          "$kotlin"
          "$lua"
          "$nim"
          "$nodejs"
          "$ocaml"
          "$perl"
          "$php"
          "$pulumi"
          "$purescript"
          "$python"
          "$rlang"
          "$red"
          "$ruby"
          "$rust"
          "$scala"
          "$swift"
          "$terraform"
          "$vlang"
          "$vagrant"
          "$zig"
          "$nix_shell"
          "$conda"
          "$memory_usage"
          "$aws"
          "$gcloud"
          "$openstack"
          "$env_var"
          "$crystal"
          "$custom"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$battery"
          "$time"
          "$status"
          "$shell"
          "$character"
        ];

        aws.disabled = true;
        battery.disabled = true;

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
          vicmd_symbol = "[➜](bold purple)";
        };

        cmake.disabled = true;
        conda.disabled = true;
        crystal.disabled = true;

        directory = {
          format = "in [$path](bold cyan) ";
        };

        docker_context.disabled = true;
        dotnet.disabled = true;
        gcloud.disabled = true;
        helm.disabled = true;

        hostname = {
          ssh_only = false;
          format = "on [$hostname](bold blue) ";
          trim_at = ".";
          disabled = false;
        };

        java.disabled = true;
        julia.disabled = true;
        hg_branch.disabled = true;

        nodejs = {
          symbol = "⬢ ";
        };

        openstack.disabled = true;

        package = {
          format = "is [$version](bold red) ";
        };

        perl.disabled = true;
        php.disabled = true;
        rlang.disabled = true;
        red.disabled = true;
        ruby.disabled = true;
        scala.disabled = true;
        singularity.disabled = true;
        terraform.disabled = true;

        username = {
          style_user = "yellow bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };

        vagrant.disabled = true;
        vlang.disabled = true;
        vcsh.disabled = true;
        zig.disabled = true;
      };
    };

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      autocd = true;

      history = {
        save = 1000;
        size = 1000;
      };

      initExtra = ''
        # Basic auto/tab complete
        autoload -U compinit
        zstyle ":completion:*" menu select
        zmodload zsh/complist
        compinit
        _comp_options+=(globdots)

        # vi mode
        bindkey -v
        export KEYTIMEOUT=1

        # Use vim keys in tab complete menu
        bindkey -M menuselect "h" vi-backward-char
        bindkey -M menuselect "k" vi-up-line-or-history
        bindkey -M menuselect "l" vi-forward-char
        bindkey -M menuselect "j" vi-down-line-or-history
        bindkey -v "^?" backward-delete-char

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
        bindkey -s "^o" "lfcd\n"

        # Edit line in vim with ctrl-e
        autoload edit-command-line; zle -N edit-command-line
        bindkey "^e" edit-command-line

        bindkey "^ " autosuggest-accept

        gp() {
          git pull
          git add .
          git commit -m "$*"
          git push
        }

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

      shellAliases = {
        sudo = "sudo -i";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        ls = "exa -F --group-directories-first";
        l = "exa -aF --group-directories-first";
        la = "exa -laF --group-directories-first --git";
        ll = "exa -lF --group-directories-first --git";
        lt = "exa -T --git-ignore";
        lr = "exa -R --git-ignore";
        mkdir = "mkdir -p";
        df = "df -kTh";
        free = "free -h";
        du = "du -h -c";
        cat = "bat";
        fd = "fdfind";
        push = "git push";
        pull="git fetch origin; git merge origin/main";
        gst = "git status";
        cleanup = "find . -name '*.DS_Store' -type f -ls -delete";
      };
    };
  };

  networking.hostName = "macbook";
  nix.useDaemon = true;
  services.nix-daemon.enable = true;

  system.stateVersion = 4;
  users.users.matt = {
    description = "Matt Cook";
    home = "/Users/matt";
    name = "matt";
    shell = pkgs.zsh;
  };
}