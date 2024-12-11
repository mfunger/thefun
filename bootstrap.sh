#! /usr/bin/env zsh


#check if oh-my-zsh is installed and being used.

if [ -f ~/.zshrc ]; then
  source ~/.zshrc
  if [ -n "$ZSH_VERSION" ]; then
    echo "Oh-My-Zsh is installed and currently being used as the shell."
  else
    echo "Oh-My-Zsh is installed, but not currently being used as the shell."
  fi
else
  echo "Oh-My-Zsh is not installed."
fi


# check if homebrew is installed
which -s brew
if [[ $? != 0 ]] ; then
  # If homebrew isn't installed, do so.
  echo "Homebrew is not installed. Installing."
  wait 5
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Install the default packages; this should only happen once. The Brewfile will be installed as a link later in this process.
  brew bundle install --file=dotfiles/homebrew/Brewfile
else
  # If homebrew is installed, update homebrew and move forward.
  echo "Homebrew is installed. Running homebrew update."
  brew update
fi

# stow
## Check to make sure that stow got installed properly
which -s stow
if [[ $? != 0 ]] ; then
  echo "Stow is not installed. Please rerun bootstrap.sh to install it with Homebrew."
  exit 1
fi

## list 
export DOTFILES_DIR="$PWD/dotfiles"
declare -a DOTFILES_TO_STOW

stow -d $DOTFILES_DIR -s .bin -t $HOME
stow -d $DOTFILES_DIR -s homebrew -t $HOME
stow -d $DOTFILES_DIR -s .oh-my-zsh  $HOME
stow -d $DOTFILES_DIR -s .config/nix-darwin -t $HOME/.config