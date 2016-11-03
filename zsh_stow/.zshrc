### 
#
# zshell main config
#
###

# set path
typeset -U path
path=(~/bin/scripts
      ~/.rvm/bin
      $path)
export PATH

# RVM nonsense
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export RAILS_ENV="development"

# disable less useless logging
export LESSHISTFILE=/dev/null

# default programs
export EDITOR=nvim
export PAGER=less
export BROWSER=firefox

## set special keys
source "$XDG_CONFIG_HOME"/zsh/zkeys

## vim mode
bindkey -v 
# change cursor color for insert and normal modes
zle-keymap-select () {
    if [ $TERM = "rxvt-unicode-256color" ]; then
        if [ $KEYMAP = vicmd ]; then
            echo -ne "\033]12;Black\007"
        else
            echo -ne "\033]12;Grey\007"
        fi
    fi
}
zle -N zle-keymap-select
zle-line-init () {
    zle -K viins
    if [ $TERM = "rxvt-unicode-256color" ]; then
        echo -ne "\033]12;Grey\007"
    fi
}
zle -N zle-line-init
# normal/insert lag time
export KEYTIMEOUT=1
# backspace and delete 
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
# ctrl-w removed word backwards
bindkey '^w' backward-kill-word


## history
# append every comand to history file, share history in real time
HISTFILE=~/.config/zsh/zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history
setopt hist_ignore_dups
setopt share_history
# search related history
[[ -n "${key[Up]}"   ]]  && bindkey  "${key[Up]}"    history-beginning-search-backward
[[ -n "${key[Down]}" ]]  && bindkey  "${key[Down]}"  history-beginning-search-forward

## command input
# no beep
unsetopt beep
# tab completion
COMPDUMPFILE=~/.config/zsh/zcompdump
setopt completealiases
zstyle :compinstall filename "$HOME/.zshrc"
autoload -U +X compinit && compinit -d ${COMPDUMPFILE}
autoload -U +X bashcompinit && bashcompinit


## directory stack
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
DIRSTACKSIZE=10
setopt autopushd pushdsilent pushdtohome pushdignoredups pushdminus


## prompt
# display exit statis if last command was not a success
# display directory and time on the right
autoload -Uz vcs_info
precmd () { vcs_info; rbv=$($HOME/.rvm/bin/rvm-prompt) }
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "[%b]"

function prompt_rvm {
  rbv=$($HOME/.rvm/bin/rvm-prompt)
    rbv=${rbv#ruby-}
    echo $rbv
}

PROMPT="%(?..[return %?]
) %~ > "
RPROMPT='${vcs_info_msg_0_}[${rbv}][%*]'


## aliases
alias pacman='sudo pacman'
alias vim='nvim'
alias vimdark='nvim -c "colorscheme darkblue"'

# if a program is currently backgrounded, ctrl-z will foreground that program
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
