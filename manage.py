#!/usr/bin/env python

import os
import shutil
import subprocess
import sys
import textwrap


BINARY_EXTENSIONS = [".jpg"]


def arglist(string):
    # TODO: handle spaces in file names
    return list(string.strip().split(" "))


def apply_substitutions(string):
    return string.replace("$$[<HOME>]$$", os.path.expanduser("~"))


def templatize(string):
    return string.replace(os.path.expanduser("~"), "$$[<HOME>]$$")


def get_config_folders():
    return sorted(
        [
            dir
            for dir in os.listdir()
            if dir[:2].isdecimal() and os.path.isfile(os.path.join(dir, "install"))
        ]
    )


class InstallMeta:
    def __init__(self, keys):
        self.packages = arglist(keys["packages"]) if "packages" in keys else []
        self.files = arglist(keys["files"]) if "files" in keys else []
        self.exec = keys["exec"].strip() if "exec" in keys else None

    @staticmethod
    def from_folder(folder):
        with open(os.path.join(folder, "install"), "r") as f:
            return InstallMeta(
                dict(
                    apply_substitutions(line).split(": ", 1)
                    for line in f.readlines()
                    if line
                )
            )


def copy_with_text_filter(src, dst, textmap, *, backup=False):
    diff = False

    _, ext = os.path.splitext(src)
    binary = ext in BINARY_EXTENSIONS
    read_flag = "rb" if binary else "r"
    write_flag = "wb" if binary else "w"
    filter = (lambda b: b) if binary else textmap

    with open(src, read_flag) as f:
        content = filter(f.read())
    with open(dst, read_flag) as f:
        diff = f.read() != content
    if backup and diff:
        shutil.copy(dst, src + ".backup")
    with open(dst, write_flag) as f:
        f.write(content)

    return diff


def update(args):
    updated = False
    for folder in get_config_folders():
        if args and not any(arg in folder for arg in args):
            continue
        install_meta = InstallMeta.from_folder(folder)
        store_files = [
            os.path.join(folder, basename)
            for basename in os.listdir(folder)
            if basename != "install"
        ]
        for system_file in install_meta.files:
            basename = os.path.basename(system_file)
            store_file = os.path.join(folder, basename)
            if store_file in store_files:
                store_files.remove(store_file)
                if copy_with_text_filter(system_file, store_file, templatize):
                    print(f"Updated: {store_file}")
                    updated = True
            else:
                copy_with_text_filter(system_file, store_file, templatize)
                print(f"New: {store_file}")
                updated = True
        for file in store_files:
            print(f"Orphan: {file}")
    print("Complete" if updated else "No changes")


def install(args):
    print("Warning: This installation script is untested! Use at your own risk.")
    print("Continue? [y/n]:", end="")
    if not input().lower().startswith("y"):
        return
    print("An AUR helper is required, what command should be used? :", end="")
    pkg = input()
    commands = []
    for folder in get_config_folders():
        if args and not any(arg in folder for arg in args):
            continue
        print(f"Installing {folder}...")
        install_meta = InstallMeta.from_folder(folder)
        packages = " ".join(install_meta.packages)
        if os.system(f"{pkg} -S {packages}") != 0:
            print("Couldn't install packages; aborting")
            return
        commands.append(install_meta.exec)
    install_files(args)
    for command in commands:
        subprocess.run(command, stdout=subprocess.DEVNULL)


def install_files(args):
    skipped = []
    for folder in get_config_folders():
        if args and not any(arg in folder for arg in args):
            continue
        print(f"Installing files from {folder}...")
        install_meta = InstallMeta.from_folder(folder)
        for system_file in install_meta.files:
            basename = os.path.basename(system_file)
            store_file = os.path.join(folder, basename)
            print(f"...Copying {store_file} -> {system_file}")
            try:
                os.makedirs(os.path.dirname(system_file), exist_ok=True)
                copy_with_text_filter(
                    store_file, system_file, apply_substitutions, backup=True
                )
            except PermissionError as e:
                print(f"...Skipping due to permission error: {e}")
                skipped.append((store_file, system_file))
    if skipped:
        print()
        print("Please copy the following files which were skipped:")
        for store_file, system_file in skipped:
            print(f"   {store_file} -> {system_file}")


def instruct(args):
    packages = []
    files = {}
    commands = []
    for folder in get_config_folders():
        if args and not any(arg in folder for arg in args):
            continue
        install_meta = InstallMeta.from_folder(folder)
        packages.extend(install_meta.packages)
        for system_file in install_meta.files:
            repo_file = os.path.join(folder, os.path.basename(system_file))
            files[repo_file] = system_file
            copy_with_text_filter(repo_file, repo_file, apply_substitutions)
        if install_meta.exec:
            commands.append(install_meta.exec)
    if packages:
        packages = " ".join(packages)
        print(f"Install the following packages (some may be AUR):\n  {packages}\n")
    if files:
        print(f"Copy the following files:")
        for src, dest in files.items():
            print(f"  {src} -> {dest}")
    if commands:
        print("\nRun the following commands and restart:")
        for command in commands:
            print(f"  $ {command}")


def usage():
    print(f"usage: {sys.argv[0]} <command>")
    print()
    print(
        textwrap.dedent(
            """
        commands:

            help     - Display this information.

            update   - Copies from system files to update the repository.

            install  - Runs an automatic installation attempt which copies files,
                       installs packages, and runs commands. I wouldn't recommend
                       using this.

            copy     - Copies files from the repository into the system, where
                       permissions allow.

            instruct - Displays which files should be copied where, which
                       packages should be installed, and which commands should
                       be run.

        To use only specific packages, pass them as extra arguments (use a
        unique substring of the directory name):

            ./manage.py update 14 15

        or

            ./manage.py copy polybar zsh conky
        """
        )
    )


def main():
    args = sys.argv[1:]
    if not args:
        usage()
    elif args[0] == "update":
        update(args[1:])
    elif args[0] == "install":
        install(args[1:])
    elif args[0] == "copy":
        install_files(args[1:])
    elif args[0] == "instruct":
        instruct(args[1:])
    else:
        usage()


if __name__ == "__main__":
    main()
