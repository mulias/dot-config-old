#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=${HOME}/bin/scripts:${PATH}
export PATH

export EDITOR="vim"
export BROWSER="firefox"

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias pacman='sudo pacman'

PS1='[\#]\w \$ '
