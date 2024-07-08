from libs.model.provider import TF_provider as ProviderDefinition
from dataclasses import dataclass
from libs.constants.variables import BTP_PROVIDER_MANDATORY_VARIABLES, BTP_PROVIDER_MANDATORY_RESOURCES, QAS_STEP1_BTP_PROVIDER_MANDATORY_VARIABLES, QAS_STEP2_BTP_PROVIDER_MANDATORY_VARIABLES
from libs.constants.variables import CF_PROVIDER_MANDATORY_VARIABLES, CF_PROVIDER_MANDATORY_RESOURCES, QAS_STEP1_CF_PROVIDER_MANDATORY_VARIABLES, QAS_STEP2_CF_PROVIDER_MANDATORY_VARIABLES
from libs.constants.variables import QAS_STEP1_BTP_PROVIDER_MANDATORY_OUTPUTS
from libs.model.finding import Finding


@dataclass
class TF_Provider(ProviderDefinition):

    def __init__(self, folder, provider, tf_definitions):
        super().__init__(folder, tf_definitions)

        self.mandatory_variables, self.mandatory_resources = determine_variables_and_resources(
            folder=folder, provider=provider)

        # only execute if the provider is btp or cloudfoundry
        if provider in ["btp", "cloudfoundry"]:
            self._check_variables_mandatory(provider, tf_definitions)
            self._check_resources_mandatory(provider, tf_definitions)
            self.folder = folder
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

    return None, None
