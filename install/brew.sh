#!/usr/bin/env bash

if test ! "$( which brew )"; then
    echo "\n\nInstalling homebrew into $HOME/local"
    mkdir -p "$BREW_INSTALL" >> /dev/null
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$BREW_INSTALL"
    mkdir -p $HOME/local/Frameworks $HOME/local/etc $HOME/local/include $HOME/local/lib $HOME/local/opt $HOME/local/sbin $HOME/local/share $HOME/local/var/homebrew/linked $HOME/local/Cellar
fi

echo -e "\\n\\nInstalling homebrew packages..."

formulas=(
    ruby
    neovim
    tmux
    diff-so-fancy
)

for formula in "${formulas[@]}"; do
    formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed... skipping."
    else
        brew install --verbose --debug "$formula"
    fi
done

gem install teamocil
mkdir -p ~/.teamocil