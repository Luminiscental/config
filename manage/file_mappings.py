import os
from typing import List, Tuple

file_locations: List[Tuple[str, str]] = [
    (".zshrc", "~/.zshrc"),
    (".xinitrc", "~/.xinitrc"),
    (".pylintrc", "~/.pylintrc"),
    (".Xresources", "~/.Xresources"),
    (".profile", "~/.profile"),
    (".bash_aliases", "~/.bash_aliases"),
    (".config/termite/config", "~/.config/termite/config"),
    (".config/cava/config", "~/.config/cava/config"),
    (".config/i3/config", "~/.config/i3/config"),
    (".config/nvim/modified_lightline_deus.vim", "~/.cache/dein/repos/github.com/itchyny/lightline.vim/autoload/lightline/colorscheme/deus.vim"),
    (".config/polybar/config", "~/.config/polybar/config"),
    (".config/redshift/redshift.conf", "~/.config/redshift/redshift.conf"),
    (".config/neofetch/config.conf", "~/.config/neofetch/config.conf"),
    (".config/KShare/settings.ini", "~/.config/KShare/settings.ini"),
    (".config/mpd/mpd.conf", "~/.config/mpd/mpd.conf"),
    (".config/compton.conf", "~/.config/compton.conf"),
    (".config/dunst/dunstrc", "~/.config/dunst/dunstrc"),
    (".config/nvim/init.vim", "~/.config/nvim/init.vim"),
    (".config/nvim/ftdetect/clr.vim", "~/.config/nvim/ftdetect/clr.vim"),
    (".config/nvim/syntax/clr.vim", "~/.config/nvim/syntax/clr.vim"),
    (".config/nvim/colors/autumn256.vim", "~/.config/nvim/colors/autumn256.vim"),
    (".config/nvim/indent/clr.vim", "~/.config/nvim/indent/clr.vim"),
    (".config/nvim/UltiSnips/c.snippets", "~/.config/nvim/UltiSnips/c.snippets"),
    (".todo/config", "~/.todo/config"),
    ("conky/system.conf", "~/conky/system.conf"),
    ("conky/todo.conf", "~/conky/todo.conf"),
    ("scripts/polybar_wrapper.sh", "~/.local/bin/polybar_wrapper.sh"),
    ("scripts/disable_mouse_accel.sh", "~/.local/bin/disable_mouse_accel.sh"),
    ("scripts/new-tex", "~/.local/bin/new-tex"),
    ("scripts/todo", "~/.local/bin/todo"),
    ("scripts/display-colors", "~/.local/bin/display-colors"),
    ("scripts/i3-get-window-criteria", "~/.local/bin/i3-get-window-criteria"),
    ("scripts/test-dunst", "~/.local/bin/test-dunst"),
    ("scripts/refresh-dunst", "~/.local/bin/refresh-dunst"),
    ("scripts/clang-format-dirs", "~/.local/bin/clang-format-dirs"),
]

def get_normalized_locations():
    for repo_location, location in file_locations:
        yield (
            __normalize_repo_location(repo_location),
            __normalize_location(location)
        )

def __normalize_repo_location(repo_location):
    repo_location = os.path.join("files", repo_location)
    return repo_location

def __normalize_location(location):
    location = os.path.expanduser(location)
    return location
