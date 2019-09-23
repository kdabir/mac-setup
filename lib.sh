
## User Interaction


# inspiration: http://unix.stackexchange.com/questions/92563/friendly-terminal-color-names-in-shell-scripts
# prints in green
# Args: *
success() {
    echo $(tput setaf 2)"$*"$(tput sgr 0)
}

already_installed() {
    echo $(tput setaf 2)"✔"$(tput sgr 0) "$* already installed"
}

terminate() {
    echo $(tput bold)$(tput setaf 1) "$@" $(tput sgr 0)
    exit 1
}

## confirm "<question>"
## accepts only "yes" as success
confirm() {
    local response="no"
    read -r -p "$1 [type 'yes']: " response
    if [ "$response" = "yes" ]; then
        return 0
    fi
    return 1
}


has_exec() {
    type $1 &> /dev/null
}

function install_app() {
  if brew cask list $1 2>/dev/null 1>/dev/null; then
    already_installed $1
  else
    brew cask install $1
  fi
}

