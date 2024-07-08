from dataclasses import dataclass, field
from pathlib import Path
from libs.model.finding import Finding


@dataclass
class TF_provider:
    """
    Represents a Terraform provider.

    Attributes:
        folder (Path): The folder path of the provider.
        mandatory_variables (list): A list of mandatory variables.
        mandatory_outputs (list): A list of mandatory outputs.
        forbidden_variables (list): A list of forbidden variables.
        required_resources (list): A list of required resources.
        forbidden_resources (list): A list of forbidden resources.
        required_provider (str): The required provider.
        required_version (str): The required version.
        findings (list[Finding]): A list of findings.
    """
    folder: Path
    mandatory_variables: list = field(default_factory=list)
    mandatory_outputs: list = field(default_factory=list)
    forbidden_variables: list = field(default_factory=list)
    required_resources: list = field(default_factory=list)
    forbidden_resources: list = field(default_factory=list)
    required_provider: str = None
    required_version: str = None
    findings: list[Finding] = field(default_factory=list)
