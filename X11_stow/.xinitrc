#! /bin/bash

~/.fehbg &                                     # wallpaper
mpd ~/.config/mpd/mpd.conf &                   # music player daemon
pcmanfm -d &                                   # automount USBs
xrdb -merge ~/.config/X11/Xresources &         # update xresources
xset b off                                     # no beep
xbindkeys -f ~/.config/xbindkeys/xbindkeysrc & # keyboard shortcuts
xcape -e '#66=Escape' &                        # tapping capslock=escape
xmodmap ~/.config/X11/Xmodmap                  # holding capslock=meta
urxvtd -q -f -o                                # terminal daemon
feedpage --daemon 45 --log                     # update rss feed aggregator
exec i3                                        # start window manager
