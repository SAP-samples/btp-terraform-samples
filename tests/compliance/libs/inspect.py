import subprocess
import json
from pathlib import Path

def get_tf_definitions(folder: Path) -> json:

    # run a command in a shell  and fetch the output
    output = subprocess.run(["terraform-config-inspect", "--json" , folder], capture_output=True)

    # convert output to json
    output = output.stdout.decode("utf-8")
    output = json.loads(output)
    return output