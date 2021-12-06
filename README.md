# dotfiles

I currently use two platforms, macOS and NixOS on Raspberry Pi. Nix home manager is accessed in different ways depending on the platform. NixOS for a single user can be entirely managed via the main `configuration.nix` file located in `/etc/nixos`. Nix home manager on Darwin is managed from the `home.nix` file located in `~/.config/nixpkgs`. Instead of creating seperate repos for the two platforms, I have put everything in this repo with the appropriate Nix configuration in its respective path for the OS.

### [Bat](https://github.com/sharkdp/bat)

[https://github.com/dracula/sublime](https://github.com/dracula/sublime)

```shell
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
git clone https://github.com/dracula/sublime
bat cache --build
```

### Emacs

First time running emacs do `M-x package-refresh-contents`

### Neovim

[Packer](https://github.com/wbthomason/packer.nvim)

```shell
git clone https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
 ~/dotfiles/zsh/zsh-syntax-highlighting
```

### Homebrew

Setting up on a new Mac.

```shell
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew install mas
```

### Truecolor Support

#### Kitty

[Emacs colors info](https://www.gnu.org/software/emacs/manual/html_node/efaq/Colors-on-a-TTY.html)

Create a file `terminfo-custom.src` in the home directory:

```shell
xterm-emacs|xterm with 24-bit direct color mode for Emacs,
use=xterm-256color,
setb24=\E[48\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&\%d\:%p1%{255}%&%dm,
setf24=\E[38\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&\%d\:%p1%{255}%&%dm,
```

```shell
tic -x -o ~/.terminfo terminfo-custom.src
```

Run Emacs with the command `TERM=xterm-emacs emacs -nw`

## Notes

#### Colors not working in macOS ($TERM)

- bat run in Nova (xterm-256color)
- bat run in tmux in Nova (tmux-256color)
- bat run on Raspberry Pi in Nova (xterm-24bits)
- bat run on Raspberry Pi in tmux in Nova (xterm-24bits)

