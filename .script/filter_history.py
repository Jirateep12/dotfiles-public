import os
import sys


def get_directory():
    os_type = os.name
    if os_type == "posix":
        return os.path.join(
            os.environ["HOME"],
            ".local",
            "share",
            "fish",
            "fish_history",
        )
    elif os_type == "nt":
        return os.path.join(
            os.environ["USERPROFILE"],
            "AppData",
            "Roaming",
            "Microsoft",
            "Windows",
            "PowerShell",
            "PSReadLine",
            "ConsoleHost_history.txt",
        )
    else:
        raise NotImplementedError("This script does not support the os.")


def read_history_file(directory):
    try:
        with open(directory, "r") as file:
            return file.readlines()
    except (FileNotFoundError, PermissionError):
        print("Error accessing the history file.")
        sys.exit(1)


def filter_lines(lines):
    os_type = os.name
    if os_type == "posix":
        return set(line for line in lines if "- cmd:" in line.strip())
    elif os_type == "nt":
        return set(line for line in lines if line.strip())
    else:
        raise NotImplementedError("This script does not support the os.")


def write_filtered_history(directory, filtered_history):
    try:
        with open(directory, "w") as file:
            file.writelines(filtered_history)
    except (FileNotFoundError, PermissionError):
        print("Error writing to the history file.")
        sys.exit(1)


def filter_history():
    directory = get_directory()
    lines = read_history_file(directory)
    filtered_history = filter_lines(lines)
    write_filtered_history(directory, filtered_history)


if __name__ == "__main__":
    filter_history()
