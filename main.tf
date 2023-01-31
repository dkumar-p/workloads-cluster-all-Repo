# provider Irlanda Default
provider "aws" {
  region = "eu-west-1"
  alias  = "prodbackoffice"
  assume_role {
    role_arn = "arn:aws:iam::772838718480:role/RoleGithubRunners_Infrastructure_Prod_backoffice"
  }
}

# provider N.virginia
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::772838718480:role/RoleGithubRunners_Infrastructure_Prod_backoffice"
  }
}

# provider Europe (Fráncfort) eu-central-1
provider "aws" {
  alias  = "francfort"
  region = "eu-central-1"
  assume_role {
    role_arn = "arn:aws:iam::772838718480:role/RoleGithubRunners_Infrastructure_Prod_backoffice"
  }
}

provider "aws" {
  alias  = "gccaddress"
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::114062091353:role/RoleGithubRunners_Infrastructure_Gcc"
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
    bucket               = "ocpame2-sb-tfs-772838718480-001"
    dynamodb_table       = "ocpame2-dd-tfs-772838718480-001"
    key                  = "workloads-prod-backoffice-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
    role_arn             = "arn:aws:iam::772838718480:role/RoleGithubRunners_Infrastructure_Prod_backoffice"
  }
}
