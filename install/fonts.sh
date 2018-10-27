#!/usr/bin/env bash
echo -e "\\n\\nInstalling fonts"
echo "=============================="
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
cd ..
rm -rf fonts
