#!/usr/bin/env bash

# SPECIFY $PATH
export PATH="/usr/local/bin:$PATH"

# ADD FILES
cd ~ # go home

if [ ! -e ".hushlogin"]; then
    touch .hushlogin
fi

sh brew/brew.sh
sh defaults/config.sh
sh defaults/defaults.sh