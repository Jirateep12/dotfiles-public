import os

if os.name == "posix":
    user_profile = os.getenv("HOME")
    file_path = os.path.join(
        user_profile,
        ".local",
        "share",
        "fish",
        "fish_history",
    )
elif os.name == "nt":
    user_profile = os.environ["USERPROFILE"]
    file_path = os.path.join(
        user_profile,
        "AppData",
        "Roaming",
        "Microsoft",
        "Windows",
        "PowerShell",
        "PSReadLine",
        "ConsoleHost_history.txt",
    )
else:
    print("Error: This script is for 'macos' and 'windows' only.")
    exit(1)

with open(file_path, "r") as file:
    lines = file.readlines()

if os.name == "posix":
    filtered_lines = []
    for line in lines:
        if "- cmd:" in line.strip():
            filtered_lines.append(line)
elif os.name == "nt":
    filtered_lines = []
    for line in lines:
        if line.strip():
            filtered_lines.append(line)
else:
    print("Error: This script is for 'macos' and 'windows' only.")
    exit(1)

deduplicated_lines = list(set(filtered_lines))

with open(file_path, "w") as file:
    file.writelines(deduplicated_lines)
