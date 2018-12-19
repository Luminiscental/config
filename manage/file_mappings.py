import os
from typing import List, Tuple

file_locations: List[Tuple[str, str]] = [
    (".zshrc", "~/.zshrc"),
    (".config/termite/config", "~/.config/termite/config"),
    (".vimrc", "~/.vimrc"),
    (".config/i3/config", "~/.config/i3/config"),
    (".config/polybar/config", "~/.config/polybar/config"),
    (".config/polybar/music.sh", "~/.config/polybar/music.sh"),
    (".config/compton.conf", "~/.config/compton.conf"),
    (".config/redshift/redshift.conf", "~/.config/redshift/redshift.conf"),
    ("scripts/polybar_wrapper.sh", "~/.local/bin/polybar_wrapper.sh"),
    ("scripts/refresh_polybar.sh", "~/.local/bin/refresh_polybar.sh"),
    ("scripts/disable_mouse_accel.sh", "~/.local/bin/disable_mouse_accel.sh"),
    ("scripts/smallest_resolution_width.py", "~/.local/bin/smallest_resolution_width.py"),
    (".bash_aliases", "~/.bash_aliases")
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
