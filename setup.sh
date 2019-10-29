#!/usr/bin/env bash

# SPECIFY $PATH
export PATH="/usr/local/bin:$PATH"

# ADD FILES
cd ~ # go home

if [ ! -e ".hushlogin"]; then
    touch .hushlogin
fi