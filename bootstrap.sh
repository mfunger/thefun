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
    # Install Homebrew
    echo "Homebrew is not installed. Installing."
    wait 5
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is installed. Running homebrew update."
    brew update
fi

