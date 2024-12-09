mod setup

export DOTFILES := (home_dir() + "/dotfiles")
default:
    if [ "$(command -v fzf)" ]; then just --choose; else just --list --list-submodules; fi

