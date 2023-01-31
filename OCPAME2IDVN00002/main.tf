
provider "aws" {
  region  = "eu-west-1"
  profile = var.main_profile
}

provider "aws" {
  alias   = "monitoring"
  region  = "eu-west-1"
  profile = var.monitoring_profile
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
    bucket               = "ocpame2-sb-tfs-772838718480-001"
    dynamodb_table       = "ocpame2-dd-tfs-772838718480-001"
    key                  = "common-vpc-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
  }
}