from libs.model.provider import TF_provider as ProviderDefinition
from dataclasses import dataclass
from libs.model.finding import Finding
from libs.constants.variables import BTP_PROVIDER_MANDATORY_VARIABLES, QAS_STEP1_BTP_PROVIDER_MANDATORY_VARIABLES, QAS_STEP2_BTP_PROVIDER_MANDATORY_VARIABLES, CF_PROVIDER_MANDATORY_VARIABLES, QAS_STEP1_CF_PROVIDER_MANDATORY_VARIABLES, QAS_STEP2_CF_PROVIDER_MANDATORY_VARIABLES
from libs.constants.resources import BTP_PROVIDER_MANDATORY_RESOURCES, CF_PROVIDER_MANDATORY_RESOURCES
from libs.constants.outputs import QAS_STEP1_BTP_PROVIDER_MANDATORY_OUTPUTS
from libs.constants.providers import PROVIDER_BTP_REQUIRED_SOURCE, PROVIDER_BTP_REQUIRED_VERSION, PROVIDER_CLOUDFOUNDRY_REQUIRED_SOURCE, PROVIDER_CLOUDFOUNDRY_REQUIRED_VERSION


@dataclass
class TF_Provider(ProviderDefinition):

    def __init__(self, folder, provider, tf_definitions):
        super().__init__(folder, tf_definitions)

        self.folder = folder
        self.mandatory_variables, self.mandatory_resources, self.mandatory_outputs = determine_variables_and_resources(
            folder=folder, provider=provider)

        # only execute if the provider is btp or cloudfoundry
        if provider in ["btp", "cloudfoundry"]:
            self._check_variables_mandatory(provider, tf_definitions)
            self._check_resources_mandatory(provider, tf_definitions)
            self._check_outputs_mandatory(provider, tf_definitions)
            self._check_providers(provider, tf_definitions)
        else:
            self = None

    def _check_variables_mandatory(self, provider, tf_definitions):

        if self.mandatory_variables:
            for variable in self.mandatory_variables:
                if variable not in tf_definitions["variables"]:
                    finding = Finding(provider=provider,
                                      folder=self.folder,
                                      asset=variable,
                                      type="variable not defined",
                                      severity="error")
                    self.findings.append(finding)

    def _check_resources_mandatory(self, provider, tf_definitions):

        if self.mandatory_resources:
            for resource in self.mandatory_resources:
                # check whether the resource is in the tf_definitions["managed_resources"] or in the tf_definitions["managed_resources"] split with a "."
                if resource not in tf_definitions["managed_resources"] and not any([resource in managed_resource.split(".") for managed_resource in tf_definitions["managed_resources"]]):
                    finding = Finding(provider=provider,
                                      folder=self.folder,
                                      asset=resource,
                                      type="resource not defined",
                                      severity="error")
                    self.findings.append(finding)

    def _check_outputs_mandatory(self, provider, tf_definitions):

        if self.mandatory_outputs:
            for output in self.mandatory_outputs:
                # check if the outputs are in the tf_definitions["outputs"]
                if output not in tf_definitions["outputs"]:
                    finding = Finding(provider=provider,
                                      folder=self.folder,
                                      asset=output,
                                      type="output not defined",
                                      severity="error")
                    self.findings.append(finding)

    def _check_providers(self, provider, tf_definitions):

        # If there are required providers for the provider
        if tf_definitions["required_providers"][provider]:

            # ... and if there is a source defined
            if tf_definitions["required_providers"][provider]["source"]:

                # ... and if the source is not the required source for the provider
                source = tf_definitions["required_providers"][provider]["source"]
                # check if the source is not the required source
                if (provider == "btp" and source.lower() not in PROVIDER_BTP_REQUIRED_SOURCE.lower()) or (provider == "cloudfoundry" and source.lower() not in PROVIDER_CLOUDFOUNDRY_REQUIRED_SOURCE.lower()):
                    # ... then create a finding that the source is not the required source
                    finding = Finding(provider=provider,
                                      folder=self.folder,
                                      asset=source,
                                      type="provider source not correct",
                                      severity="error")
                    self.findings.append(finding)

            else:
                # ... then create a finding that the source is not defined
                finding = Finding(provider=provider,
                                  folder=self.folder,
                                  asset="provider",
                                  type="provider source not defined",
                                  severity="error")
                self.findings.append(finding)

            # ... and if there are version constraints defined
            if tf_definitions["required_providers"][provider].get("version_constraints"):
                # ... and if the version constraints are not the required version for the provider
                version_constraints = tf_definitions["required_providers"][provider]["version_constraints"]
                # check if the list of version_constraints is not equal to the required version (which is a string)
                if (provider == "btp" and PROVIDER_BTP_REQUIRED_VERSION not in version_constraints) or (provider == "cloudfoundry" and PROVIDER_CLOUDFOUNDRY_REQUIRED_VERSION not in version_constraints):
                    finding = Finding(provider=provider,
                                      folder=self.folder,
                                      asset=version_constraints,
                                      type="provider version not correct",
                                      severity="error")
                    self.findings.append(finding)


def determine_variables_and_resources(folder, provider):

    variables = None
    resources = None
    outputs = None

    qas_two_step_approach = None

    if "step1" in str(folder):
        qas_two_step_approach = "step1"
    if "step2" in str(folder):
        qas_two_step_approach = "step2"

    if provider == "btp":
        if qas_two_step_approach is None:
            variables = BTP_PROVIDER_MANDATORY_VARIABLES
            resources = BTP_PROVIDER_MANDATORY_RESOURCES
            return variables, resources, outputs
        else:
            if qas_two_step_approach == "step1":
                variables = QAS_STEP1_BTP_PROVIDER_MANDATORY_VARIABLES
                outputs = QAS_STEP1_BTP_PROVIDER_MANDATORY_OUTPUTS
                return variables, resources, outputs
            if qas_two_step_approach == "step2":
                variables = QAS_STEP2_BTP_PROVIDER_MANDATORY_VARIABLES
                return variables, resources, outputs

    if provider == "cloudfoundry":
        if qas_two_step_approach is None:
            variables = CF_PROVIDER_MANDATORY_VARIABLES
            resources = CF_PROVIDER_MANDATORY_RESOURCES
            return variables, resources, outputs
        else:
            if qas_two_step_approach == "step1":
                variables = QAS_STEP1_CF_PROVIDER_MANDATORY_VARIABLES
                return variables, resources, outputs
            if qas_two_step_approach == "step2":
                variables = QAS_STEP2_CF_PROVIDER_MANDATORY_VARIABLES
                return variables, resources, outputs

    return None, None, None
