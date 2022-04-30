#!/usr/bin/env python

import os


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


def copy_with_text_filter(src, dst, textmap, *, checkdiff=False):
    diff = False

    _, ext = os.path.splitext(src)
    binary = ext in BINARY_EXTENSIONS
    read_flag = "rb" if binary else "r"
    write_flag = "wb" if binary else "w"
    filter = (lambda b: b) if binary else textmap

    with open(src, read_flag) as f:
        content = filter(f.read())
    if checkdiff:
        with open(dst, read_flag) as f:
            diff = f.read() != content
    with open(dst, write_flag) as f:
        f.write(content)

    return diff


def update():
    updated = False
    for folder in get_config_folders():
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
                if copy_with_text_filter(
                    system_file, store_file, templatize, checkdiff=True
                ):
                    print(f"Updated: {store_file}")
                    updated = True
            else:
                copy_with_text_filter(system_file, store_file, templatize)
                print(f"New: {store_file}")
                updated = True
        for file in store_files:
            print(f"Orphan: {file}")
    print("Complete" if updated else "No changes")


def install():
    print("Warning: This installation script is untested! Use at your own risk.")
    print("Continue? [y/n]:", end="")
    if not input().lower().startswith("y"):
        return
    print("An AUR helper is required, what command should be used? :", end="")
    pkg = input()
    commands = []
    for folder in get_config_folders():
        print(f"Installing {folder}...")
        install_meta = InstallMeta.from_folder(folder)
        packages = " ".join(install_meta.packages)
        if os.system(f"{pkg} -S {packages}") != 0:
            print("Couldn't install packages; aborting")
            return
        for system_file in install_meta.files:
            basename = os.path.basename(system_file)
            store_file = os.path.join(folder, basename)
            os.makedirs(os.path.dirname(system_file), exist_ok=True)
            copy_with_text_filter(store_file, system_file, apply_substitutions)
        commands.append(install_meta.exec)
    print("Please run the following commands and restart:")
    for command in commands:
        print(f"$ {command}")


def instruct():
    packages = []
    files = {}
    commands = []
    for folder in get_config_folders():
        install_meta = InstallMeta.from_folder(folder)
        packages.extend(install_meta.packages)
        for system_file in install_meta.files:
            repo_file = os.path.join(folder, os.path.basename(system_file))
            files[repo_file] = system_file
            copy_with_text_filter(repo_file, repo_file, apply_substitutions)
        if install_meta.exec:
            commands.append(install_meta.exec)
    packages = " ".join(packages)
    print(f"Install the following packages (some are AUR):\n  {packages}\n")
    print(f"Copy the following files:")
    for src, dest in files.items():
        print(f"  {src} -> {dest}")
    print("\nRun the following commands and restart:")
    for command in commands:
        print(f"  $ {command}")


def main():
    print(
        "\n0) Quit\n1) Update repository files\n2) Install from repository\n3) Display manual installation instructions\nChoice: ",
        end="",
    )
    while not (action := input().strip()) in ["1", "2", "3"]:
        if action == "0":
            return
        print("Enter a choice from 0-3: ", end="")
    print()
    if action == "1":
        update()
    if action == "2":
        install()
    if action == "3":
        instruct()


if __name__ == "__main__":
    main()
