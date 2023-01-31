/*
provider "aws" {
  region  = "eu-west-1"
  profile = var.main_profile
}
*/
provider "aws" {
  region = "eu-west-1"
  alias  = "prodbackoffice"
  assume_role {
    role_arn = "arn:aws:iam::772838718480:role/RoleGithubRunners_Infrastructure_Prod_backoffice"
  }
}
