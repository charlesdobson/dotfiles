#!/usr/bin/env bash


# Show User Library
chflags nohidden ~/Library/

# Remove Auto-Hide Dock Delay
defaults write com.apple.Dock autohide-delay -float 0 && killall Dock

# Add Quit option to Finder
defaults write com.apple.finder QuitMenuItem -bool true; killall Finder