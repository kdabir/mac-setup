#!/usr/bin/env bash

## fail if encountered an error
set -e

########################################################################################################################
# The script starts with defining some library functions and then setup_* functions
# Each setup function can be called independently and multiple times
#
########################################################################################################################

## Global Vars
## Array of apps to be installed
apps_to_be_installed=()
## TODO
cli_tools_to_be_installed=()

## User Interaction
## confirm "<question>"
## accepts only "yes" as success
confirm() {
    local response="no"
    read -r -p "$1 [type 'yes|y', default is no]: " response
    if [ "$response" = "yes" ] || [ "$response" = "y" ]; then
        return 0
    fi
    return 1
}

has_exec() {
    type $1 &>/dev/null
}

# colored output functions
# inspiration: http://unix.stackexchange.com/questions/92563/friendly-terminal-color-names-in-shell-scripts
# prints in green
# Args: *
success() {
    echo $(tput setaf 2)"$*"$(tput sgr 0)
}

alert() {
    echo $(tput setaf 99)"$*"$(tput sgr 0)
}

already_installed() {
    echo $(tput setaf 2)"✔"$(tput sgr 0) "$* already installed"
}

terminate() {
    echo $(tput bold)$(tput setaf 1) "$@" $(tput sgr 0)
    exit 1
}

## required $1 → APP_ID
function install_app() {
    local APP_ID=$1
    local APP_NAME=${2:-${APP_ID}}

    if brew cask list "${APP_ID}" 2>/dev/null 1>/dev/null; then
        already_installed "${APP_NAME}"
    else
        if confirm "Install ${APP_NAME}?"; then
            apps_to_be_installed+=("${APP_ID}")
            echo "✔ enqueued $APP_NAME (${APP_ID})"
        else
            echo "✗ skipping $APP_NAME ($APP_ID)"
        fi
    fi
}

########################################################################################################################
# This needs to be called only once per machine, but is safe to be called multiple times
## installs various prerequisites
########################################################################################################################
setup_init() {
    echo "In this section we will install XCode Command Line Tools, Homebrew, Oh My Zsh, SDKMAN"

    if xcode-select -p 1>/dev/null; then
        already_installed "Command line tools"
    else
        xcode-select --install
    fi

    ## https://docs.brew.sh/Installation
    if has_exec brew; then
        already_installed "Homebrew"
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

    success "Init complete. If this was first time you ran init, please open a new terminal window before using other setup functions"
}

setup_devtools() {

    ## Install node and npm
    brew install node

    ## Install node based tools
    npm install -g n
    npm install -g yarn
    npm install -g pnpm
    npm install -g nodemon
    npm install -g jest

    # source just in case sdkman was freshly installed
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    sdk install java
    sdk install kotlin
    sdk install groovy
    sdk install gradle
    sdk install maven
    sdk install micronaut
    sdk install springboot

    brew install golang
    brew install rustup
    rustup-init
    brew install vlang
}

setup_cli() {
    echo "setting up basic cli tools"

    ## zsh completion & oh-my-zsh need some additional tuning, so skipping it for now
    # brew install zsh-completions
    # brew install zsh-autosuggestions

    brew install tree
    brew install autojump
    brew install fswatch
    brew install fdupes

    ## MacOS File Tags
    brew install tag

    ## better find
    brew install fd

    # better ls
    brew install exa

    ## Better Searching
    brew install ack
    brew install the_silver_searcher
    brew install ripgrep

    ## Git CLI base Interface
    brew install tig

    ## source files LoC
    brew install cloc

    ## Performance testing
    brew install siege

    ## Http Tools
    brew install wget
    brew install curl
    brew install httpie

    ## SQL query for CSV  - https://github.com/harelba/q
    brew install q

    ## Json Processing
    brew install jq
    brew install fx

    # gnu datamash for simple CLI based stats
    # https://www.gnu.org/software/datamash/
    brew install datamash

    ## Dead simple terminal plots from JSON data
    ## https://github.com/sgreben/jp
    brew install jp

    ## CSV to JSON
    npm i -g csvtojson

    ## Snippet Manager
    brew install knqyf263/pet/pet

}

function install_after_confirmation() {
  if confirm "Install latest version of $1?"; then
    brew install "$1"
  fi
}

setup_preinstalled(){
    alert "Following tools come preinstalled with MacOS"
    alert "We will install the latest version using Homebrew (without removing the preinstalled versions)"
    alert "Please note the caveats printed post installation for future reference"

    for tool in bash zsh git make curl python ruby; do
      install_after_confirmation $tool
    done
}

setup_apps() {
    echo "In this section we will install various Apps (mostly GUI). You will be asked for confirmation for each app"

    echo ">> Internet and communication"
    install_app google-chrome "Google Chrome"
    success Sign-in in chrome and create profiles for work and personal
    install_app firefox "Firefox"
    install_app firefox-developer-edition "Firefox Developer Edition"
    install_app zoomus "Zoom.us Meeting"
    install_app slack "Slack"
    install_app discord "Discord"
    install_app microsoft-teams "Microsoft Teams"
    install_app google-chat "Google Chat"
    install_app skype "Skype"
    install_app whatsapp "WhatsApp"
    install_app telegram "Telegram"

    echo ">> Productivity"
    install_app dropbox "Dropbox"
    install_app google-drive "Google Drive"
    install_app google-drive-file-stream "Google Drive File Stream"
    install_app evernote "Evernote"
    install_app notion "Notion (notion.so)"
    install_app obsidian "Obsidian"
    install_app alfred "Alfred (launcher)"
    install_app 1password "1Password"
    install_app 1password-cli "1Password CLI"
    install_app typora "Typora Markdown editor"
    install_app drawio "Draw.io / Diagrams.net"
    install_app freeplane "Freeplane (Mindmapping)"
    install_app libreoffice "Libre Office"

    echo ">> Development Tools"
    install_app iterm2 "iTerm2 v3+"
    install_app hyper "Hyper - electron based terminal "
    install_app warp "Warp - rust-based terminal"

    install_app sublime-text "Sublime Text 3+"
    install_app visual-studio-code "VS Code"
    install_app intellij-idea "IntelliJ IDEA Ultimate"
    install_app intellij-idea-ce "IntelliJ IDEA Community"
    install_app anaconda
    install_app docker

    ## Install Postgres.app
    install_app postgres-unofficial "Postgres.app"
    alert "Open postgres.app and initialize Database"$()

    if [ ! -f /etc/paths.d/postgresapp ]; then
        sudo mkdir -p /etc/paths.d
        echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
        ## to dedupe if path entered twice
        ## sudo sort -u -o /etc/paths.d/postgresapp /etc/paths.d/postgresapp
    fi
}

# Cloud Development Tools
setup_cloud() {
    echo "setup cloud development tools"

    ## Heroku
    ## brew tap heroku/brew && brew install heroku
    if confirm "Install Heroku CLI?"; then
        brew install heroku/brew/heroku
    fi

    ## Serverless
    if confirm "Install Serverless Framework?"; then
        npm install -g serverless
    fi

    ### AWS Tooling
    if confirm "Install AWS Tooling?"; then
        brew install s3cmd
        brew install awscli
        brew install awsebcli
        brew install awslogs
        brew install aws/tap/aws-sam-cli
    fi

    ## Google Cloud
    if confirm "Install Google Cloud SDK & Firebase?"; then
        brew install --cask google-cloud-sdk
        npm install -g firebase-tools
    fi

    ## Netlify
    if confirm "Install Netlify CLI?"; then
        npm install -g netlify-cli
    fi

}

setup_quicklook() {
    brew install --cask qlcolorcode
    brew install --cask qlstephen
    brew install --cask quicklook-json
}

setup_settings() {
    echo "setup preferences"

    if confirm "Show scrollbars when scrolling?"; then
        defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
    fi

    ## Keyboard
    if confirm "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"; then
        defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    fi

    if confirm "Set a blazingly fast keyboard repeat rate?"; then
        defaults write NSGlobalDomain KeyRepeat -int 0
    fi

    if confirm "Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons?"; then
        defaults write com.apple.finder QuitMenuItem -bool true
    fi

    if confirm "Disable menu bar transparency?"; then
        defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
    fi

    if confirm "Use current directory as default search scope in Finder?"; then
        defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    fi

    ## Dock - move to left
    if confirm "Move Dock to left?"; then
        defaults write com.apple.dock orientation -string left
    fi

    if confirm "Allow text selection in Quick Look?"; then
        defaults write com.apple.finder QLEnableTextSelection -bool true
    fi

    if confirm "Disable the warning when changing a file extension?"; then
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    fi

    if confirm "Avoid creating .DS_Store files on network volumes?"; then
        defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    fi

    # try at your own risk
    if confirm "Enable tap to click (Trackpad)?"; then
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    fi

    if confirm "Enable tap to click (Mouse)?"; then
        defaults -currentHost write 'Apple Global Domain' com.apple.mouse.tapBehavior 1
        defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    fi

    if confirm "Show all filename extensions in Finder?"; then
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    fi

    if confirm "Disable Shadow in Screen Capture?"; then
        defaults write com.apple.screencapture disable-shadow -bool TRUE
    fi

    if confirm "Disable the 'Are you sure you want to open this application?' dialog?"; then
        defaults write com.apple.LaunchServices LSQuarantine -bool false
    fi

    # Show the ~/Library folder
    if confirm "Show the ~/Library folder?"; then
        chflags nohidden ~/Library
    fi

    ## TextEdit - enable plain-text mode
    if confirm "TextEdit - enable plain-text mode?"; then
        defaults write com.apple.TextEdit RichText -int 0
    fi
}

setup_updates() {

    # commands for cleanup and maintenance
    # update and upgrade homewbrew
    brew update
    brew outdated

    brew upgrade --all

    brew cleanup
    brew cleanup --cask

    # commands for cleanup and maintenance of sdkman
    sdk selfupdate
    sdk upgrade
    sdk flush temp
    sdk flush archives
    sdk flush broadcast

    ## https://docs.npmjs.com/updating-packages-downloaded-from-the-registry#updating-all-globally-installed-packages
    npm update -g

    ## Upgrade Oh My ZSH
    upgrade_oh_my_zsh

}

print_help() {
    local progname=$(basename $0)
    echo "Usage: $progname <command> [options]"
    echo "where command can be any one of the following"
    declare -F | cut -d ' ' -f 3 | grep 'setup_' | sed 's/setup_//g'
}

########################################################################################################################
# calls the setup_* function based on the first argument
########################################################################################################################
setup() {
    subcommand=$1

    case $subcommand in
    "" | "-h" | "--help")
        print_help
        ;;
    *)
        shift
        setup_"${subcommand}" $@
        if [ $? = 127 ]; then
            terminate "unknown command '$subcommand'. use --help to see all valid options/commands"
        fi
        ;;
    esac
}

########################################################################################################################
# Main
########################################################################################################################
setup $@

########################################################################################################################
# Finally, install all the enqueued apps, if any
########################################################################################################################
if [ ${#apps_to_be_installed[@]} -gt 0 ]; then ## if array is not empty

    echo "apps to be installed: ${#apps_to_be_installed[@]}, it may take a while..."

    for APP_ID in "${apps_to_be_installed[@]}"; do
        echo $APP_ID
        brew install --cask "${APP_ID}"
    done
fi
