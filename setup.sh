#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# SPECIFY $PATH
export PATH="/usr/local/bin:$PATH"

git pull origin master;

function setupHome() {
	rsync --exclude ".DS_Store" \
		--exclude "README.md" \
        --exclude "*.sh" \
        --exclude "*.terminal" \
        --exclude ".git/" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	setupHome;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		setupHome;
	fi;
fi;
unset setupHome;


# EXECUTE SCRIPTS
sh scripts/brew.sh
sh scripts/config.sh
sh scripts/defaults.sh