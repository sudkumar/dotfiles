#!/usr/bin/env bash

if test ! "$( which brew )"; then
    echo "Installing homebrew into $HOME/local"
    mkdir -p "$BREW_INSTALL" >> /dev/null
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$BREW_INSTALL"
fi

echo -e "\\n\\nInstalling homebrew packages..."
echo "=============================="

formulas=(
    ack
    diff-so-fancy
    fzf
    git
    git-standup
    'grep --with-default-names'
    neovim
    tmux
    zsh
    zplug
    the_silver_searcher
    ripgrep
    vim
    python
    ruby
)

for formula in "${formulas[@]}"; do
    formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed... skipping."
    else
        brew install --verbose --debug "$formula"
    fi
done

brew tap caskroom/fonts
brew cask install font-hack-nerd-font

# After the install, setup fzf
echo -e "\\n\\nRunning fzf install script..."
echo "=============================="
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish


# after the install, install neovim python libraries
echo -e "\\n\\nRunning Neovim Python install"
echo "=============================="
pip2 install --user neovim
pip3 install --user neovim

gem install teamocil
mkdir -p ~/.teamocil

# Change the default shell to zsh
zsh_path="$( which zsh )"
if ! grep "$zsh_path" /etc/shells; then
    echo "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    echo "default shell changed to $zsh_path"
fi
