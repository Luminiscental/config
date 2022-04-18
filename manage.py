#!/usr/bin/env python

import os


BINARY_EXTENSIONS = [".jpg"]


def arglist(string):
    return list(string.strip().split(" "))


def exclude(item, list):
    list.remove(item)
    return list


def apply_substitutions(string):
    return string.replace("$$[<HOME>]$$", os.path.expanduser("~"))


def templatize(string):
    return string.replace(os.path.expanduser("~"), "$$[<HOME>]$$")


def update():
    configs = [
        dir
        for dir in os.listdir()
        if dir[:2].isdecimal() and os.path.isfile(os.path.join(dir, "install"))
    ]
    for config in sorted(configs):
        print(config)
        with open(os.path.join(config, "install"), "r") as install_file:
            install_metadata = dict(
                apply_substitutions(line).split(": ", 1)
                for line in install_file.readlines()
                if line
            )
        if "files" in install_metadata:
            repo_basenames = exclude("install", os.listdir(config))
            for system_filename in arglist(install_metadata["files"]):
                basename = os.path.basename(system_filename)
                repo_filename = os.path.join(config, basename)
                print(f"  ... {system_filename} -> {repo_filename}")
                _, ext = os.path.splitext(system_filename)
                if ext in BINARY_EXTENSIONS:
                    with open(system_filename, "rb") as system_file:
                        content = system_file.read()
                    with open(repo_filename, "wb") as repo_file:
                        repo_file.write(content)
                else:
                    with open(system_filename, "r") as system_file:
                        content = templatize(system_file.read())
                    with open(repo_filename, "w") as repo_file:
                        repo_file.write(templatize(content))
                if basename in repo_basenames:
                    repo_basenames.remove(basename)
                else:
                    print(f"  New file: {os.path.join(config, basename)}")
            for basename in repo_basenames:
                print(f"  Orphaned file: {os.path.join(config, basename)}")
    print("\nDone")


def install():
    raise NotImplementedError


def main():
    print(
        "\n0) Quit\n1) Update repository files\n2) Install from repository\n\nChoice: ",
        end="",
    )
    while not (action := input().strip()) in ["1", "2"]:
        if action == "0":
            return
        print("Enter a choice from 0-2: ", end="")
    print()
    if action == "1":
        update()
    else:
        assert action == "2"
        install()


if __name__ == "__main__":
    main()
