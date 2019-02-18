## Sourced by others such as .bash_profile and .zprofile ## 

# Update path
PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"

# Xorg server start
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# MPD daemon start
[[ ! -s ~/.config/mpd/pid ]] && mpd

