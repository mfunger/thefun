# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="agnoster"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM="$ZSH"

# PLUGINS

plugins=(
    asdf 
    aws
    brew
    colored-man-pages 
    command-not-found 
    docker 
    fzf 
    git 
    gh 
    golang 
    kubectl 
    poetry 
    python
    thefuck
    tmux
    # kube-ps1
    # vagrant
    )

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR="vim"
# else
#   export EDITOR="mvim"
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

#  Conf and aliases

## PROMPT
# PROMPT='$(kube_ps1)'$PROMPT

## colors
# RED_B="\e[1;91m"
# GREEN_B="\e[1;92m"
# YELLOW_B="\e[1;93m"
# BLUE_B="\e[1;94m"
# PURPLE_B="\e[1;95m"
# CYAN_B="\e[1;96m"
# WHITE_B="\e[1;97m"
# RESET="\e[0m"

# red() { echo -e "${RED_B}${1}${RESET}"; }
# green() { echo -e "${GREEN_B}${1}${RESET}"; }
# yellow() { echo -e "${YELLOW_B}${1}${RESET}"; }
# blue() { echo -e "${BLUE_B}${1}${RESET}"; }
# purple() { echo -e "${PURPLE_B}${1}${RESET}"; }
# cyan() { echo -e "${CYAN_B}${1}${RESET}"; }
# white() { echo -e "${WHITE_B}${1}${RESET}"; }

## syntax hightlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function new() {
    if [[ $# -eq 0 ]]; then
        open -a "iterm" "$PWD"
    else
        open -a "iterm" "$@"
    fi
}

## enable comments "#" expressions in the prompt shell
setopt INTERACTIVE_COMMENTS

## append new history entries to the history file
setopt APPEND_HISTORY

## save each command to the history file as soon as it is executed
setopt INC_APPEND_HISTORY

## ignore recording duplicate consecutive commands in the history
setopt HIST_IGNORE_DUPS

## ignore commands that start with a space in the history
setopt HIST_IGNORE_SPACE

## search history using Up and Down keys
### >>> up arrow | down arrow
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
### >>> Home | End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

## enable comments "#" expressions in the prompt shell
setopt INTERACTIVE_COMMENTS

## repos
alias repos="cd $HOME/repos"
alias mediocrity="cd $HOME/repos/mfunger/mediocrity"
alias thefun="cd $HOME/repos/mfunger/thefun"
alias ppi="cd $HOME/repos/platypi"
alias whoop="cd $HOME/repos/whoop"

## 1Password
### SSH
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

## aws
export AWS_PAGER=""

## asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

## curl
export PATH="$PATH:/opt/homebrew/opt/curl/bin"

## fzf
export FZF_BASE="$HOME/.fzf"

## go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

## homebrew
export PATH="$PATH:/opt/homebrew/bin"
export HOMEBREW_NO_INSTALL_UPGRADE=1
export HOMEBREW_NO_AUTO_UPDATE=1

## IaC
### terragrunt
export TERRAGRUNT_IGNORE_EXTERNAL_DEPENDENCIES=true
### OpenTofu
alias ot="tofu"

## java
export JDK_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home/
### jenv
eval "$(jenv init -)"

## k8s
export KUBECTL_EXTERNAL_DIFF="colordiff -N -u"
### krew
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
### rancher desktop
export PATH="$PATH:$HOME/.rd/bin"

## macos
alias dns-flush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

## nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## oh-my-zsh
alias zshconf="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh
### autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
### completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

## postgres
# export PATH="$PATH:/opt/homebrew/opt/postgresql@11/bin"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

## python
alias p3="python3"
### pyenv
eval "$(pyenv init -)"
PATH="$(pyenv root)/shims:${PATH}"
export PATH

## starship
eval "$(starship init zsh)"
# export STARSHIP_CONFIG="$HOME/.starship/starship.toml"
# export STARSHIP_CACHE=~/$STARSHIP_CONFIG/cache

## tcl-tk
export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
export PATH=$PATH:/usr/local/opt/tcl-tk/bin

## yt-dlp
alias ytm="yt-dlp -x --audio-format aac --embed-thumbnail"
alias yt137="yt-dlp -f 137"
alias yt616="yt-dlp -f 616"


# Created by `pipx` on 2025-02-21 15:01:16
export PATH="$PATH:/Users/matthew.unger/.local/bin"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/matthew.unger/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions


