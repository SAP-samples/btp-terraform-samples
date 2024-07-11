from pathlib import Path
import re
from typing import List

# function to write a string into a file


def write_string_to_file(string_data, file_path):
    """
    Writes a given string into a file specified by the file_path.
    If the file does not exist, it will be created.
    If the file exists, it will be overwritten.

    :param file_path: Path to the file where the string will be written.
    :param string_data: The string data to write into the file.
    """
    with open(file_path, 'w') as file:
        file.write(string_data)

# read all folders in the tfscripts folder


def get_folders(folder_to_scan: Path) -> List[Path]:
    """
    Get all folders and subfolders in the FOLDER_SCRIPTS folder that contain at least one .tf file.

    Returns:
        List[Path]: A list of Path objects representing the folders that contain .tf files.
    """
    folders = [folder for folder in Path(folder_to_scan).glob("**/*") if folder.is_dir(
    ) and any([re.match(r".*\.tf", file.name) for file in folder.iterdir()])]

    return folders
