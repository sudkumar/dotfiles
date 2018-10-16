#!/usr/bin/env bash

if test ! "$( which brew )"; then
    echo "Installing homebrew into $HOME/local"
    mkdir -p "$BREW_INSTALL" >> /dev/null
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$BREW_INSTALL"
fi
