#!/usr/bin/env bash
set +e
source ./lib.sh

to_be_installed=$()

## required $1 → APP_ID
function install_app() {
  local APP_ID=$1
  local APP_NAME=${2:-${APP_ID}}

  if brew cask list "${APP_ID}" 2>/dev/null 1>/dev/null; then
    already_installed "${APP_NAME}"
  else
    if confirm "Install ${APP_NAME}?"; then
      to_be_installed+=("${APP_ID}")
      echo "✔ enqueued $APP_NAME (${APP_ID})"
    else
      echo "✗ skipping $APP_NAME ($APP_ID)"
    fi
  fi
}

## Internet and communication
install_app google-chrome "Google Chrome"
success Sign-in chrome and create profiles for work and personal
install_app firefox-developer-edition "Firefox Developer Edition"
install_app slack
install_app zoomus "Zoom.us Meeting"

## Productivity
install_app dropbox "Dropbox"
install_app google-backup-and-sync "Google Backup and Sync"
install_app google-drive-file-stream "Google Drive File Stream"

install_app evernote "Evernote"
install_app notion "Notion (notion.so)"

install_app alfred "Alfred (launcher)"
# older version: alfred3
install_app 1password "1Password"
# older version : 1password6
install_app 1password-cli "1Password CLI"

install_app typora "Typora Markdown editor"
install_app drawio "Draw.io / Diagrams.net"
install_app freeplane "Freeplane (Mindmapping)"
install_app libreoffice "Libre Office"

## Development Tools
install_app iterm2 "iTerm2 v3+"
install_app sublime-text "Sublime Text 3+"
install_app visual-studio-code "VS Code"
install_app intellij-idea "IntelliJ IDEA Ultimate"
install_app intellij-idea-ce "IntelliJ IDEA Community"
install_app anaconda
install_app docker

## Install Postgres.app
install_app postgres "Postgres.app"
alert "Open postgres.app and initialize Database"``

if [ ! -f /etc/paths.d/postgresapp ]; then
  sudo mkdir -p /etc/paths.d
  echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
  ## just to dedupe if path entered twice
  sort -u -o /etc/paths.d/postgresapp /etc/paths.d/postgresapp
fi

###########################################
# Finally install all the enqueued items
for APP_ID in "${to_be_installed[@]}"; do
  # echo $APP_ID
  brew cask install "${APP_ID}"
done
