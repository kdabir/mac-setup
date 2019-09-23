#!/usr/bin/env bash

set -e

# commands for cleanup and maintenance
# update and upgrade homewbrew
brew update
brew outdated
brew upgrade --all
brew cleanup
brew cask cleanup


# commands for cleanup and maintenance of sdkman
sdk selfupdate
sdk upgrade

## https://docs.npmjs.com/updating-packages-downloaded-from-the-registry#updating-all-globally-installed-packages
npm update -g

## Upgrade Oh My ZSH
upgrade_oh_my_zsh
