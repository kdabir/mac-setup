# Mac Setup

MacOS machine ready for development.

**Warning:** Highly opinionated stuff ahead :)  

## Installation


### Without downloading

`curl -sL https://raw.githubusercontent.com/kdabir/mac-setup/main/setup.sh | bash -s -- init`


### Donwloading locally

`git clone` or download the [zip](https://github.com/kdabir/mac-setup/archive/refs/heads/main.zip) file of the project


## Installation Notes

This project can be downloaded/checked-out anywhere (directory), deleted and cloned again. It does not store any state 
in the working directory (where it is checked out). The script is idempotent and hence can be run as many times whether 
it is fresh machine or not.

## Running 

If it's a fresh machine, you won't have developer tools and git installed, so start with this command first `./setup.sh init`

- help: `./setup.sh --help`

- dev-tools: `./setup.sh devtools`

- upgrade all tools:   `./setup.sh updates`

- self-upgrade: `git pull --rebase`


## Troubleshooting

### Running in non-interactive mode because `stdin` is not a TTY.

```
Warning: Running in non-interactive mode because `stdin` is not a TTY.
==> Checking for `sudo` access (which may request your password)...
```

<img width="610" alt="image" src="https://user-images.githubusercontent.com/735240/220915542-af029edc-2110-4f6f-a229-08cf0f11e015.png">

If you get this error then don't run off using curl piped to bash, instead clone the repo

```bash
$ git clone https://github.com/kdabir/mac-setup.git
$ cd mac-setup
$ ./setup.sh init
```


## Customizations

Fork it off and have fun :)
