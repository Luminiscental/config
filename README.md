# config

This is a collection of files for me to keep track of the system configuration
and software that I like to use. The script `manage.py` is used for interacting
with the repository.

The configuration is for an Arch Linux system, with `install` files referencing
official and AUR packages. In theory the stuff in this repo could be applied and
work out of the box if the system has been set up following the
[install guide](https://wiki.archlinux.org/title/Installation_guide) (including
the configuration and post-installation sections), but most likely something
crucial is missing. There is a combination of both global and (non-root)
user-specific configuration.

The folders split into three groups by number:
- 2* for sway (wayland) setup
- 1* for i3 (X11) setup
- 0* for everything else
