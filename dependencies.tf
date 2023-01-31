data "terraform_remote_state" "globalsharedservices" {
  backend = "s3"

  config = {
    bucket               = "ocpame2-sb-tfs-601472654169-001"
    key                  = "globalsharedservices-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
    role_arn             = "arn:aws:iam::601472654169:role/RoleGithubRunners_Infrastructure_Gss"
    #profile              = var.globalsharedservices_profile
  }
}

/*data "terraform_remote_state" "networking" { 
  backend = "s3"

  config = {
    bucket               = "ocpame2-sb-tfs-713508239187-001"
    key                  = "networking-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
    #profile              = var.networking_profile
    role_arn = "arn:aws:iam::713508239187:role/RoleGithubRunners_Networking"
  }
}*/

data "terraform_remote_state" "gccaddress" {
  backend = "s3"

  config = {
    bucket               = "ocpame2-sb-tfs-114062091353-001"
    key                  = "gccaddress-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
    #profile              = "aws-iberia-sso-gccaddress"
    role_arn = "arn:aws:iam::114062091353:role/RoleGithubRunners_Infrastructure_Gcc"
  }
}
