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
  echo "Oh My Zsh is not installed."
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Oh My Zsh installed, make sure to restart the terminal session."
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

## Stow what we need

export $ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
echo "stow -d dotfiles -S homebrew -t $HOME"
stow -d dotfiles -S homebrew -t $HOME
echo "stow -d dotfiles -S .oh-my-zsh -t $ZSH_CUSTOM"
stow -d dotfiles -S .oh-my-zsh -t $ZSH_CUSTOM
echo "stow -d dotfiles -S zsh -t $HOME"
stow -d dotfiles -S zsh -t $HOME
echo "stow -d dotfiles -S ssh -t $HOME/.ssh
#reload oh my zsh to capture the changes
omz reload