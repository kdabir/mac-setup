# Mac Setup

MacOS machine ready for development.

**Warning:** Highly opinionated stuff ahead :)  

# Installation

`git clone` or download zip of the project

OR 

`curl -sL https://raw.githubusercontent.com/kdabir/mac-setup/main/setup.sh | bash`



This project can be downloaded/checked-out anywhere (directory), deleted and cloned again. It does not store any state 
in the working directory (where it is checked out). The script is idempotent and hence can be run as many times whether 
it is fresh machine or not.

If it's a fresh machine, you won't have developer tools and git installed, so start with this command first `./setup.sh init`


- help: `./setup.sh --help`

- dev-tools: `./setup.sh devtools`

- upgrade all tools:   `./setup.sh updates`

- self-upgrade: `git pull --rebase`


Fork it off and have fun
