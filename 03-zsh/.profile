## Sourced by others such as .bash_profile and .zprofile ## 

# Update path
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"

# Ruby gems
export GEM_HOME="$HOME/.local/share/gem"

# System information for polybar
export MONITOR=HDMI-A-0
export NETWORK_INTERFACE=enp8s0

# Use nvim by default
export VISUAL=nvim
export EDITOR="$VISUAL"

# X11

#if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
#    exec startx
#fi

# Wayland

if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then

    # flameshot fixes
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export QT_QPA_PLATFORM=wayland
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway

    exec sway
fi
