terraform {
  backend "remote" {
    hostname     = "<hostname of the artifactory>"
    organization = "<name of the artifactory repository>"

    workspaces {
      name = "<WORKSPACE NAME>"
    }
  }
}
