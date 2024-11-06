#!/bin/bash

######### CONSTANTS #########
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_BACKUP_DIR="$HOME/.dotfiles-backup"

OHMYZSH_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh"
ZOXIDE_URL="https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh"

######### SHELL COLOURS #########
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NORMAL='\033[0m'

######### UTIL FUNCTIONS #########

function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

function dotfiles {
   /usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME $@
}

function is_installed() {
    local dependancy="$1"
    local condition="$2"
    local install_callback="$3"

    if eval "test $condition"; then
        prompt_install "$dependancy" "$install_callback"
    fi
}

function prompt_install() {
    local dependancy="$1"
    local install_callback="$2"

    echo -en "${CYAN}$dependancy not installed. Install? [Y/n]: ${NORMAL}"
    read choice
    case "$choice" in
        y|Y )
            eval "$install_callback"
            ;;
        n|N )
            ;;
        * )
            prompt_install "$dependancy" "$install_callback"
            ;;
    esac
}

######### START INSTALL SCRIPT  #########
# Check for dependencies
command_exists git || {
    echo -e "${RED}git is not installed. Please ensure git is installed prior to running this script.${NORMAL}"
    exit 1
}

command_exists curl || {
    echo -e "${RED}curl is not installed. Please ensure curl is installed prior to running this script.${NORMAL}"
    exit 1
}

# Check if zsh is installed
command_exists zsh || {
    prompt_install "ZSH" "apt install zsh -y"
}

# Check if ohmyzsh is installed
test -d "$ZSH" || {
    prompt_install "ohmyzsh" "curl -fsSL $OHMYZSH_URL | bash"
}
# echo -e "Spawning a new ${CYAN}zsh${NORMAL} shell. Once complete, rerun this script with ${CYAN}curl -Lks https://raw.githubusercontent.com/MasterOfCubesAU/.dotfiles/main/install_dotfiles.sh | /bin/bash${NORMAL}"
# zsh

# Check if nvm is installed
command_exists nvm || {
    prompt_install "nvm" "curl -o- $NVM_URL | bash"
    source "$HOME/.zshrc"
}

# Check if zoxide is installed
command_exists zoxide || {
    prompt_install "zoxide" "curl -sSfL $ZOXIDE_URL | sh"
}

# Check if batcat is installed
command_exists batcat || {
    prompt_install "batcat" "apt install bat -y"
}

# Clone the dotfiles repo
echo -e "${CYAN}Cloning the dotfiles repo...${NORMAL}"
git clone --bare git@github.com:MasterOfCubesAU/.dotfiles.git $DOTFILES_DIR


# # Back up existing dotfiles if necessary
# if ! dotfiles checkout > /dev/null 2>&1; then
#     echo "Backing up pre-existing dot files.";
#     dotfiles checkout 2>&1 | egrep "\s+\..*/" | awk {'print $1'} | xargs -I{} dirname {} | xargs -I{} mkdir -p $DOTFILES_BACKUP_DIR/{}
#     dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $DOTFILES_BACKUP_DIR/{}
#     dotfiles checkout
# fi;

# echo "Applied dotfiles";
# dotfiles config status.showUntrackedFiles no

# rm -- "$HOME/README.md" "$HOME/install_dotfiles.sh" 


# Change shell to zsh
chsh -s "$zsh" "$USER"
