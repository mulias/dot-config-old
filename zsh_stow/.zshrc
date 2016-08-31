### 
#
# zshell main config
#
###

export XDG_CONFIG_HOME="$HOME"/.config
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc-2.0
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc-1.0

## set paths
export GOPATH=~/.go
# set path
typeset -U path
path=(~/bin/dmenu_tools
      ~/bin/dmenu_music
      ~/bin/scripts
      ~/bin/feedpage
      $(ruby -rubygems -e 'puts Gem.user_dir')/bin
      $GOPATH/bin
      $path)
export PATH

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
bindkey '^k' up-history
bindkey '^j' down-history
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward


## command input
# no beep
unsetopt beep
# tab completion
COMPDUMPFILE=~/.config/zsh/zcompdump
setopt completealiases
zstyle :compinstall filename "$HOME/.zshrc"
autoload -U +X compinit && compinit -d ${COMPDUMPFILE}
autoload -U +X bashcompinit && bashcompinit
# search for unknown commands
source /usr/share/doc/pkgfile/command-not-found.zsh


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
PROMPT="%(?..[return %?]
) %~ > "
RPROMPT="%*"


## aliases
# monkey patching
alias ls='lsdasha'
alias pacman='sudo pacman'
alias medit='medit 2> /dev/null'
alias top='htop'
alias acpi='sudo tpacpi-bat_info'
alias vim='nvim'
alias skype='apulse32 skype'
# regular use
alias vimdark='nvim -c "colorscheme darkblue"'
alias apps='pcmanfm menu://applications/'
alias wallpaper='feh -. ~/Pictures/Wallpaper'
alias mathlan='ssh mulhalle@www.cs.grinnell.edu'
alias todo='note todo'
alias vimf='nvim $(fzf)'
# switch between config files to tell skype what kind of mic I have
alias builtinmic='cp ~/.asoundrc /tmp/asoundrc.tmp && mv ~/.asoundrc.builtin ~/.asoundrc && mv /tmp/asoundrc.tmp ~/.asoundrc.usbmic'
alias usbmic='cp ~/.asoundrc /tmp/asoundrc.tmp && mv ~/.asoundrc.usbmic ~/.asoundrc && mv /tmp/asoundrc.tmp ~/.asoundrc.builtin'
# sometimes flashplayer breaks if it is updated while firefox is running
# remove currupted pluginreg.dat and everything should be fine
alias fixflash='killall firefox; rm ~/.mozilla/firefox/*/pluginreg.dat'
# hypothetically useful
alias terminal='urxvtc'
alias projector='xrandr --output VGA1 --auto --left-of LVDS1;xset s off'
alias fromclip='xclip -out -selection clipboard | xclip'
alias toclip='xclip -out | xclip -selection clipboard'
alias batmin='sudo tpacpi-bat -s ST 1'
alias batmax='sudo tpacpi-bat -s SP 1'
alias batdischarge='sudo tpacpi-bat -s FD 1'
alias batinhibit='sudo tpacpi-bat -s IC 1'
alias diskspace='df -h'
alias webcam='vlc v4l:// :v4l-vdev="/dev/video0" :v4l-adev="/dev/audio2"'
alias lanshare='echo http://$(ifconfig | grep -A1 wlp3s0 | awk "/inet/{ print \$2 }"):8000 ; ruby -e "require\"webrick\";w=WEBrick::HTTPServer.new(:Port=>8000,:DocumentRoot=>Dir::pwd);Signal.trap(2){w.shutdown};w.start"'
alarm () { sleep $*; mpv --loop=inf /usr/share/sounds/freedesktop/stereo/complete.oga }
# paramount importance
alias salsamixer='alsamixer'
alias topdown="vlc -f ~/Videos/Elephant\ \&\ Giraffe\ Ridin\'\ with\ Their\ Top\ Down.mp4"
alias starwars='telnet towel.blinkenlights.nl'
alias infinicows='n=32; cow=$(cowsay "moo"); for i in $(seq $n); do cow=$(echo "$cow" | cowsay -n); done; echo "$cow"'

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

## source 
# source custome completion scripts
source ~/bin/scripts/note_completion

## OPAM configuration
# used by opam to automagically add ocaml packages to path 
. /home/eli/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# rbenv config
eval "$(rbenv init -)"
