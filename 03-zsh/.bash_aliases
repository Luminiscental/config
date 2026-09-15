alias realias="source ~/.bash_aliases"

alias ls="ls -h --color=auto"
alias grep="grep --color"
alias vim="nvim"

if [ -n "$WAYLAND_DISPLAY" ]; then
    alias soulseek="QT_QPA_PLATFORM=xcb soulseekqt"
fi
