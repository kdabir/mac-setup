#!/usr/bin/env bash

## typically used once per new machine, however safe to be called multiple times

source ./lib.sh

if xcode-select -p 1>/dev/null; then
  already_installed "Command line tools"
else
  xcode-select --install
fi

## https://docs.brew.sh/Installation
if has_exec brew; then
  already_installed "Homebrew"
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


## Oh-my-zsh at default location
## https://github.com/robbyrussell/oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  already_installed "Oh My Zsh!"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi


## Version Managers - for languages/platforms like JVM, Node, Ruby, Python etc.
## Currently I need only JVM (Java, Groovy, Kotlin, Scala) related multiple versions
## we can add tools like RVM, NVM, GVM etc here.

## https://sdkman.io/install
if [ -d "$HOME/.sdkman/bin" ]; then
  already_installed "SDKMAN"
else
  curl -s "https://get.sdkman.io" | bash
fi
