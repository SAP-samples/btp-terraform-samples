from libs.constants.files_folders import FOLDER_SCRIPTS
from libs.inspect import get_tf_definitions
from libs.inspection.provider import TF_Provider
from libs.io.files import get_folders
import sys

folder_to_scan = None

# if a parameter is provided, use it as the folder to start scanning
if len(sys.argv) > 1:
    folder_to_scan = sys.argv[1]
else:
    # Otherwise take the default folder defined in FOLDER_SCRIPTS
    folder_to_scan = FOLDER_SCRIPTS

# get all folders
folders = get_folders(folder_to_scan)

found_findings = False

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

    # exit the code with an error code if there are any findings
    if len(all_findings) > 0:
        # loop through all findings and print them
        message_text = "# " + "-" * 120 + "\n"
        message_text += f"# Findings in {folder}\n"
        message_text += "# " + "-" * 120 + "\n"

        for finding in all_findings:
            # if the severity is error, print the finding in red
            if finding.severity == "error":
                message_text += f"# - {finding.type} ({finding.provider} provider) '{finding.asset}'\n"
                # Set flag to indicate that findings were found
                found_findings = True

        print(message_text)
        # Store file in folder
        # filename = Path(folder, "TF_compliance_TODO.txt")
        # write_string_to_file(string_data=message_text, file_path=filename)

# exit the code with an error code if there are any findings
if found_findings:
    sys.exit(1)
# exit the code with a success code if there are no findings
else:
    sys.exit(0)
