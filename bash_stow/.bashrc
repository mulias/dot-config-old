#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PATH=${HOME}/bin/dmenu_tools:${HOME}/bin/ruby-dmusic:${HOME}/bin/cute:${HOME}/bin/scripts:${HOME}/.gem/ruby/2.0.0/bin:${HOME}/.gem/ruby/2.1.0/bin:${PATH}
export PATH

export EDITOR="vim"
export BROWSER="firefox"

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias ls='lsdasha'
alias pacman='sudo pacman'
alias medit='medit 2> /dev/null'
alias top='htop'
alias salsamixer='alsamixer'
alias terminal='urxvt'
alias wallpaper='feh -. ~/Pictures/Wallpaper1600x900'
alias todo='note todo'
alias topdown="vlc -f Videos/Elephant\ \&\ Giraffe\ Ridin\'\ with\ Their\ Top\ Down.mp4"
alias projector='xrandr --output VGA1 --auto --left-of LVDS1;xset s off'
alias fromclip='xclip -out -selection clipboard | xclip'
alias toclip='xclip -out | xclip -selection clipboard'
alias mathlan='ssh mulhalle@ssh.cs.grinnell.edu'
alias vnc='x11vnc -nocursorshape -display :0 -rfbauth ~/.x11vnc/passwd'
alias batmin='sudo tpacpi-bat -s ST 1'
alias batmax='sudo tpacpi-bat -s SP 1'
alias batdischarge='sudo tpacpi-bat -s FD 1'
alias batinhibit='sudo tpacpi-bat -s IC 1'
alias acpi='sudo tpacpi-bat_info'

PS1='[\#]\w \$ '
