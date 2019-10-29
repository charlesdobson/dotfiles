#!/usr/bin/env bash


# SETUP
which -s brew
if [[ $? != 0 ]] ; then
    echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
echo "Upgrading Homebrew"
brew upgrade
echo "Updating Homebrew"
brew update
echo "Installing brew cask"
brew tap caskroom/cask
echo # newline


# INSTALL BREW APPS
declare -a apps=(
    'mas'
    'n'
    'redis'
    'yarn'
)
echo "Installing brew apps"
for app in "${apps[@]}"; do
    echo "      Installing ${app}"
    brew install "$app"
done
echo # newline


# INSTALL BREW CASK APPS
declare -a cask_apps=(
    'bitwarden'
    'chatmate-for-whatsapp'
    'docker'
    'firefox'
    'google-chrome'
    'keepingyouawake'
    'slack'
    'spotify'
    'tidal'
    'visual-studio-code'
)
echo "Installing brew cask apps"
for cask_app in "${cask_apps[@]}"; do
    echo "      Installing ${cask_app}"
    brew cask install "$cask_app"
done
echo # newline


# CLEANUP
brew cleanup