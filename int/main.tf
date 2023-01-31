
## provider Irlanda Default
#provider "aws" {
#  region  = "eu-west-1"
#  profile = var.main_profile
#}
#
## provider N.virginia
#provider "aws" {
#  alias   = "virginia"
#  region  = "us-east-1"
#  profile = var.main_profile
#}
#
## provider Europe (Fráncfort) eu-central-1
#provider "aws" {
#  alias   = "francfort"
#  region  = "eu-central-1"
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
  alias  = "intbackoffice"
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::459208450119:role/RoleGithubRunners_Infrastructure_Int_backoffice"
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
    role_arn             = "arn:aws:iam::459208450119:role/RoleGithubRunners_Infrastructure_Int_backoffice"
    bucket               = "ocpame2-sb-tfs-459208450119-001"
    dynamodb_table       = "ocpame2-dd-tfs-459208450119-001"
    key                  = "backoffice-finance-sla3-ews-infra-8015-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
  }
}
