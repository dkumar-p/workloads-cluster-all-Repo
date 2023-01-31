
## provider Ireland Default
#provider "aws" {
#  region  = "eu-west-1"
#  profile = var.main_profile
#}
#
#provider "aws" {
#  alias   = "globalsharedservices"
#  region  = "eu-west-1"
#  profile = var.globalsharedservices_profile
#}
#
#provider "aws" {
#  alias   = "networking"
#  region  = "eu-west-1"
#  profile = var.networking_profile
#}
#

provider "aws" {
  alias  = "prebackoffice"
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::771030194710:role/RoleGithubRunners_Infrastructure_Pre_backoffice"
  }
}


provider "aws" {
  alias  = "networking"
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::713508239187:role/RoleGithubRunners_Networking"
  }
}

terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }

  backend "s3" {
    role_arn             = "arn:aws:iam::771030194710:role/RoleGithubRunners_Infrastructure_Pre_backoffice"
    bucket               = "ocpame2-sb-tfs-771030194710-001"
    dynamodb_table       = "ocpame2-dd-tfs-771030194710-001"
    key                  = "backoffice-finance-sla3-ews-infra-8015-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
  }
}
