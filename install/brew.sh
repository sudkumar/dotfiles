#!/usr/bin/env bash

if test ! "$( which brew )"; then
    echo "Installing homebrew into $HOME/local"
    mkdir -p "$BREW_INSTALL" >> /dev/null
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$BREW_INSTALL"
    mkdir -p $HOME/local/Frameworks $HOME/local/etc $HOME/local/include $HOME/local/lib $HOME/local/opt $HOME/local/sbin $HOME/local/share $HOME/local/var/homebrew/linked $HOME/local/Cellar
fi
