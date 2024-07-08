import re
from pathlib import Path
from typing import List
from libs.constants.files_folders import FOLDER_SCRIPTS
from libs.inspect import get_tf_definitions
from libs.inspection.provider import TF_Provider
from libs.io.files import write_string_to_file, get_folders

folder_to_scan = None


# get all folders
folders = get_folders(folder_to_scan)

# iterate through all folders
for folder in folders:
    all_findings = []
    # run the inspect_folder function
    defs = get_tf_definitions(folder)

    for provider in defs["required_providers"]:
        result = TF_Provider(folder=folder, provider=provider,
                             tf_definitions=defs)
        if len(result.findings) > 0:
            all_findings.extend(result.findings)

    # loop through all findings and print them
    message_text = "# " + "-" * 120 + "\n"
    message_text += f"# Findings in {folder}\n"
    message_text += "# " + "-" * 120 + "\n"

    for finding in all_findings:
        # if the severity is error, print the finding in red
        if finding.severity == "error":
            message_text += f"# - {finding.type} ({finding.provider} provider) '{finding.asset}'\n"

    print(message_text)
    filename = Path(folder, "TF_compliance_TODO.txt")
    write_string_to_file(string_data=message_text, file_path=filename)
