# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="jonathan"
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
    # asdf 
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
    # vagrant
    )

# oh-my-zsh
source $ZSH/oh-my-zsh.sh
## autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
## completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
## syntx hightlight
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## starship
# eval "$(starship init zsh)"
# export STARSHIP_CONFIG="$HOME/.starship/starship.toml"
# export STARSHIP_CACHE=~/$STARSHIP_CONFIG/cache
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

#  Conf and aliases

## colors
RED_B='\e[1;91m'
GREEN_B='\e[1;92m'
YELLOW_B='\e[1;93m'
BLUE_B='\e[1;94m'
PURPLE_B='\e[1;95m'
CYAN_B='\e[1;96m'
WHITE_B='\e[1;97m'
RESET='\e[0m'

red() { echo -e "${RED_B}${1}${RESET}"; }
green() { echo -e "${GREEN_B}${1}${RESET}"; }
yellow() { echo -e "${YELLOW_B}${1}${RESET}"; }
blue() { echo -e "${BLUE_B}${1}${RESET}"; }
purple() { echo -e "${PURPLE_B}${1}${RESET}"; }
cyan() { echo -e "${CYAN_B}${1}${RESET}"; }
white() { echo -e "${WHITE_B}${1}${RESET}"; }

# IaC
alias tf='terraform'
alias tg='terragrunt'

# oh-my-zsh
alias zshconf="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

#python
alias p3='python3'

## yt-dlp
alias ytm="yt-dlp -x --audio-format aac --embed-thumbnail"
alias yt137="yt-dlp -f 137"
alias yt616="yt-dlp -f 616"

## repos

alias repos="cd $HOME/repos"
alias mediocrity="cd $HOME/repos/mfunger/mediocrity"
alias thefun="cd $HOME/repos/mfunger/thefun"
alias ppi="cd $HOME/repos/platypi"

## 1Password
### SSH
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

## curl
export PATH="$PATH:/opt/homebrew/opt/curl/bin"

## fzf
export FZF_BASE="$HOME/.fzf"

## go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

## IaC
### tg
export TERRAGRUNT_IGNORE_EXTERNAL_DEPENDENCIES=true

# k8s
### krew
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
### rancher desktop
export PATH="$PATH:$HOME/.rd/bin"

# homebrew
export PATH="$PATH:opt/homebrew/bin"
export HOMEBREW_NO_INSTALL_UPGRADE=1
export HOMEBREW_NO_AUTO_UPDATE=1

## postgres
# export PATH="$PATH:/opt/homebrew/opt/postgresql@11/bin"

# python
## tcl-tk
export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
export PATH=$PATH:/usr/local/opt/tcl-tk/bin

# aliases (until I can figure out custom alias in oh my zsh)
# boilerplate
#alias boilerplate='/opt/homebrew/bin/boilerplate_darwin_arm_64'

## homebrew
export PATH="$PATH:/opt/homebrew/bin"


# IaC
alias tf='terraform'
alias tg='terragrunt'

# oh-my-zsh
alias zshconf="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

#python
alias p3='python3'

## yt-dlp
alias ytm="yt-dlp -x --audio-format aac --embed-thumbnail"
alias yt137="yt-dlp -f 137"
alias yt616="yt-dlp -f 616"