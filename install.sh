#!/usr/bin/env bash

export DOTFILES="$HOME/.dotfiles"
export BREW_INSTALL="$HOME/local"

command_exists() {
    type "$1" > /dev/null 2>&1
}

echo "Installing dotfiles."

source install/link.sh

# only perform macOS-specific install
if [ "$(uname)" == "Darwin" ]; then
    echo -e "\\n\\nRunning on OSX"
    source install/brew.sh
fi

source install/git.sh

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
echo "run nvm install --lts to install lts node"

echo "Done. Reload your terminal."
