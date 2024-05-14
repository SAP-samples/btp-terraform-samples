terraform {
  backend "remote" {
    hostname     = "<hostname of the artifactory eg: >"
    organization = "<name of the artifactory repository>"

    workspaces {
      name = "my-workspace-"
    }
  }
}