data "terraform_remote_state" "workloads-sdlc-int-backoffice" {
  backend = "s3"

  config = {
    role_arn             = "arn:aws:iam::459208450119:role/RoleGithubRunners_Infrastructure_Int_backoffice"
    bucket               = "ocpame2-sb-tfs-459208450119-001"
    key                  = "workloads-sdlc-int-backoffice-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
    #    profile              = var.main_profile
  }
}

## state global share services
#data "terraform_remote_state" "globalsharedservices" {
#  backend = "s3"
#
#  config = {
#    bucket               = "ocpame2-sb-tfs-601472654169-001"
#    key                  = "globalsharedservices-infra.tfstate"
#    workspace_key_prefix = "workspaces"
#    region               = "eu-west-1"
#    profile              = var.globalsharedservices_profile
#  }
#}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    role_arn             = "arn:aws:iam::713508239187:role/RoleGithubRunners_Networking"
    bucket               = "ocpame2-sb-tfs-713508239187-001"
    key                  = "networking-infra.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
    #    profile              = var.networking_profile
  }
}
