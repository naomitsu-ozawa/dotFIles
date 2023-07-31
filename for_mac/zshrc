# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# 

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH=$(brew --prefix)/opt/fzf/install:$FPATH
    autoload -Uz compinit
    compinit
fi


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PROMPT="%n@%m(`uname -m`) %1~ %# "

alias arm="exec arch -arch arm64e /bin/zsh --login"
alias x64="exec arch -arch x86_64 /bin/zsh --login"

function code {
    if [[ $# = 0 ]]
    then
        open -a "Visual Studio Code"
    else
        local argPath="$1"
        [[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
        open -a "Visual Studio Code" "$argPath"
    fi
}

#
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

#customAlias
alias ls="lsd"
alias lt='lsd --tree'
alias la='lsd -a'
alias l='lsd'
alias ll='lsd -l'
alias lla='lsd -al'
alias nv="nvim"

#
## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
#        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
#    else
#        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi


source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Load Plugin
zinit light zsh-users/zsh-autosuggestions
zinit light momo-lab/zsh-abbrev-alias
zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions
zinit light mollifier/anyframe
zinit light b4b4r07/enhancd
zinit light zdharma-continuum/history-search-multi-word

zinit ice depth=1; zinit light romkatv/powerlevel10k

zstyle ':completion:*' list-colors "${LS_COLORS}" # 補完候補のカラー表示
zstyle ':completion:*:default' menu select=1
# zstyle ':completion:*' menu select interactive
# setopt menu_complete



# $LS_COLORS
if [ "$LS_COLORS" -a -f /etc/DIR_COLORS ]; then
    eval $(dircolors /etc/DIR_COLORS)
fi

#anyframe
zstyle ":anyframe:selector:" use fzf
bindkey '^w' anyframe-widget-cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
bindkey '^r' anyframe-widget-execute-history
bindkey '^f' anyframe-widget-insert-filename
bindkey '^y' anyframe-widget-put-history
# Gitブランチを表示して切替え
bindkey '^g^b' anyframe-widget-checkout-git-branch
# GHQでクローンしたGitリポジトリを表示
bindkey '^g' anyframe-widget-cd-ghq-repository


# FZF&Enhancd
source "$HOME/ghq/github.com/b4b4r07/enhancd/init.sh"
export BAT_THEME="Solarized (dark)"
export FZF_DEFAULT_OPTS=" \
    --reverse \
    --border none \
    --height 100% \
    --preview 'bat  --color=always --style=full {}'  \
    --preview-window border-none \
    "
export ENHANCD_FILTER="fzf --preview 'tree -C {} | head -200'"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Codon compiler path (added by install script)
export PATH=/Users/ozawa/.codon/bin:$PATH

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


