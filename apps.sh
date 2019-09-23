#!/usr/bin/env bash

source ./lib.sh

install_app google-chrome
success Sign-in chrome and create profiles for work and personal

install_app iterm2
install_app sublime-text
install_app visual-studio-code
install_app freeplane

if confirm "Install IntelliJ IDEA Ultimate?"; then
  install_app intellij-idea
fi

if confirm "Install IntelliJ IDEA Community?"; then
  install_app intellij-idea-ce
fi

