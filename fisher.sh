#!/usr/bin/env fish

if test -z "$FISH_VERSION"
    echo "Please run this script inside fish shell."
    exit 1
end

if not type -q fisher
    echo "Installing fisher."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

echo "Installing fisher plugins."
while read -l plugin
    fisher install $plugin
end < "$PWD/.requirements/fisher.txt"

if not type -q nvm
    echo "Nvm is not installed."
    exit 1
end

echo "Installing node lts version."
nvm install lts

echo "Using node lts version."
nvm use lts

set --universal nvm_default_version lts

if not type -q npm
    echo "Npm is not installed."
    exit 1
end

echo "Installing npm packages."
while read -l package
    npm install -g $package
end < "$PWD/.requirements/npm.txt"
