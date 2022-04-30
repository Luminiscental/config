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
        self.exec = keys.get("exec")

    def dump(self):
        print(f"packages: {self.packages}")
        print(f"files: {self.files}")
        print(f"exec: {self.exec}")

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


def ensure_parents(file):
    raise NotImplementedError


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
    for folder in get_config_folders():
        install_meta = InstallMeta.from_folder(folder)
        # TODO: packages?
        for system_file in install_meta.files:
            basename = os.path.basename(system_file)
            store_file = os.path.join(folder, basename)
            ensure_parents(system_file)
            copy_with_text_filter(store_file, system_file, apply_substitutions)
        # TODO: commands?


def dump():
    for folder in get_config_folders():
        print(f"{folder}:")
        InstallMeta.from_folder(folder).dump()
        print()


def main():
    print(
        "\n0) Quit\n1) Update repository files\n2) Install from repository\n3) Dump metadata\nChoice: ",
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
        dump()


if __name__ == "__main__":
    main()
