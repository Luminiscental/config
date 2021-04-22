## Sourced by others such as .bash_profile and .zprofile ## 

# Update path
PATH="/usr/local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.cabal/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.emacs.d/bin:$PATH"

# Use nvim by default
export VISUAL=nvim
export EDITOR="$VISUAL"

# rust cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Xorg server start
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# MPD daemon start
[[ ! -s ~/.config/mpd/pid ]] && mpd ~/.config/mpd/mpd.conf

# Start fcitx
fcitx -d -r

# Turn tablet upside down
xsetwacom --set "Wacom One by Wacom S Pen stylus" Rotate half

streaks update
