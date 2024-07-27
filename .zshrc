export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="philips"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Aliases

alias cd=z
alias c=cd
alias cat=batcat
alias v=vim
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

_SSHFS_ZID=z1234567
_SSHFS_CSE_MOUNT="$HOME/cse"

alias csemount="mkdir -p ${_SSHFS_CSE_MOUNT} && sshfs -o idmap=user -C ${_SSHFS_ZID}@login.cse.unsw.edu.au: ${_SSHFS_CSE_MOUNT}"
alias cseunmount="fusermount -zu ${_SSHFS_CSE_MOUNT} && rmdir ${_SSHFH_CSE_MOUNT}"

function cse() {
    # determine where we are relative to the mountpoint (thanks @ralismark)
    local rel=${PWD##${_SSHFS_CSE_MOUNT}}

    if [ -z "$1" ]; then
        # if we don't have arguments, we give the user a shell on the remote cse machine.
        if [ "$PWD" = "$rel" ]; then
            # in the case that we're not in our mountpoint, provide a shell in their home directory.
            ssh "${_SSHFS_ZID}@login.cse.unsw.edu.au"
        else
            # if within the mountpoint, cd to the equivalent dir on the remote before providing a shell (thanks @ralismark)
            ssh "${_SSHFS_ZID}@login.cse.unsw.edu.au" -t "cd $(printf "%q" "./$rel"); exec \$SHELL -l"
        fi
    else
        # if we have arguments, we have a command to execute.
        if [ "$PWD" = "$rel" ]; then
            # in the case that we're not in our mountpoint, we'll execute in the home directory.
            ssh -qt "${_SSHFS_ZID}@login.cse.unsw.edu.au" "$@"
        else
            # if within the mountpoint, cd to the equivalent dir on the remote before executing (thanks @ralismark)
            ssh "${_SSHFS_ZID}@login.cse.unsw.edu.au" -qt "cd $(printf "%q" "./$rel") && $(printf "%q " "$@")"
        fi
    fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(zoxide init zsh)"
