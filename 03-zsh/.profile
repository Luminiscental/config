## Sourced by others such as .bash_profile and .zprofile ## 

# Update path
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Use nvim by default
export VISUAL=nvim
export EDITOR="$VISUAL"

# Xorg server start
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# Start programs
fcitx5 -d -r
