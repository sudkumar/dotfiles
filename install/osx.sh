#!/usr/bin/env bash

echo -e "\\n\\nSetting OS X settings"
echo "=============================="

function set_font {
    osascript -e "tell application \"Terminal\" to set the font name of window 1 to \"$1\""
    osascript -e "tell application \"Terminal\" to set the font size of window 1 to $2"
}

echo "setting the fonts"
set_font "Source Code Pro Medium for Powerline" 14
