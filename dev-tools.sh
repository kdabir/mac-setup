#!/usr/bin/env bash

source ./lib.sh

set +e

## upgrade the tools that come with system
brew install zsh bash git make ruby curl

brew install --cask  docker
brew install --cask  anaconda

brew install node

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java
sdk install kotlin
sdk install groovy


npm install -g yarn
npm install -g nodemon
npm install -g gulp
npm install -g jest

