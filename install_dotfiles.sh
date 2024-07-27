DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_BACKUP_DIR="$HOME/.dotfiles-backup"

# Clone the dotfiles repo
git clone --bare git@github.com:MasterOfCubesAU/.dotfiles.git $DOTFILES_DIR

# Define a git alias
function dotfiles {
   /usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME $@
}

# Back up existing dotfiles if necessary
if ! dotfiles checkout > /dev/null 2>&1; then
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\..*/" | awk {'print $1'} | xargs -I{} dirname {} | xargs -I{} mkdir -p $DOTFILES_BACKUP_DIR/{}
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $DOTFILES_BACKUP_DIR/{}
    dotfiles checkout
fi;

echo "Applied dotfiles";
dotfiles config status.showUntrackedFiles no

rm -- "$HOME/README.md" "$0" 
