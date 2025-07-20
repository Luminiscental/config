## Sourced by others such as .bash_profile and .zprofile ## 

# Update paths
export MANPATH="/usr/local/texlive/2023/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2023/texmf-dist/doc/info:$INFOPATH"

export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/texlive/2023/bin/x86_64-linux:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

# Ruby gems
export GEM_HOME="$HOME/.local/share/gem"

# System information for polybar
export MONITOR=HDMI-A-1
export NETWORK_INTERFACE=enp8s0

# Use nvim by default
export VISUAL=nvim
export EDITOR="$VISUAL"

# Fix for Qt apps on wayland
if [ -n "$WAYLAND_DISPLAY" ]; then
    export QT_QPA_PLATFORM=wayland
fi

# flameshot fixes
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
