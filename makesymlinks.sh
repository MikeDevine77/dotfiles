#!/bin/bash
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## This script creates symlinks from the users home directory to any 
## desired dotfiles in dotfiles repo
##
## The dot DOTFILES_TO_SYNC are referred to in git without 
## their eponymous dot
##
## Adding a new file: 
## ~~~~~~~~~~~~~~~~~~
## Copy the source file to the dotfiles repo and push it
## Add the file name minus the . to the list of DOTFILES_TO_SYNC 
## script variable 
## 
## Changing a file:
## ~~~~~~~~~~~~~~~~
## Edit the file locally, push it to the repo
## 
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Script Variables
##
DOTFILES_DIR=~/dev/dotfiles                    # dotfiles directory
BACKUP_DIR=/tmp/dotfiles_old             # old dotfiles backup directory
DOTFILES_TO_SYNC="vimrc zprofile zshrc"					# list of files/folders to symlink in homedir


# create dotfiles_old in homedir
echo -n "Creating backups of .files in $BACKUP_DIR... "
mkdir -p $BACKUP_DIR
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $DOTFILES_DIR directory... "
cd $DOTFILES_DIR
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, 
# create symlinks from the homedir to any files in the ~/dotfiles 
# directory specified in $DOTFILES_TO_SYNC
for file in $DOTFILES_TO_SYNC; do 
    echo "Backing up ${file} to ${BACKUP_DIR}"
    mv ~/.$file $BACKUP_DIR/$file_`date +%d%m%Y-%H%M%S`

				if [[ -L ~/.$file ]]; then
					echo "link to file already exists!"
				else 
						echo "Creating symlink to $file in home directory."
						ln -s $DOTFILES_DIR/$file ~/.$file
				fi
done

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d ~/.oh-my-zsh/ ]]; then
			git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

# Suppressing zsh installation as seems to not play well on mac
# install_zsh
