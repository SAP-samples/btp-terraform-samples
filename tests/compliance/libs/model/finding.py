from dataclasses import dataclass
from pathlib import Path


@dataclass
class Finding:
    """
    Represents a finding in the system.

    Attributes:
        provider (str): The provider of the finding.
        folder (Path): The folder where the finding is located.
        asset (str): The asset associated with the finding.
        type (str): The type of the finding.
        severity (str): The severity level of the finding.
    """
    provider: str
    folder: Path
    asset: str
    type: str
    severity: str
