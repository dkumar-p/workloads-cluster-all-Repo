## BACKEND TERRAFORM:
# bucket               = "ocpame2-sb-tfs-459208450119-001"
# dynamodb_table       = "ocpame2-dd-tfs-459208450119-001"


tags = {
  "company"                      = "iberia"
  "delete_after"                 = "Never"
  "environment"                  = "prod"
  "typeproject"                  = "infra-common"
  "owner"                        = "cdc-nordcloud"
  "project"                      = "iberia"
  "sponsor"                      = "iberia"
  "terraform"                    = "true"
  "ib:resource:op-co-code"       = "ib"
  "group:component-grouping"     = "backoffice-finance--sla3--ews--infra-8015"
  "ib:resource:environment"      = "prod"
  "ib:account:environment"       = "prod"
  "ib:account:short_name"        = "wsprodbackoffice"
  "ib:account:name"              = "workloads-prod-backoffice"
  "ib:resource:business-domain"  = "i.e"
  "ib:resource:business-service" = "i.e"
  "ib:account:service-offering"  = "i.e"
  "ib:resource:letter-ev"        = "p"
  "Ib:account:environment-type"  = "prod"

}

account_number = "772838718480"
main_profile   = "aws-iberia-sso-workloads-prod-backoffice"
#globalsharedservices_profile = "aws-iberia-sso-globalsharedservices"
networking_profile = "aws-iberia-sso-networking"
monitoring_profile = "aws-iberia-sso-monitoring"

## VPC sla3-ews-infra-8015 -----------------------------------------------------------------
## python3 signed_request.py POST "https://ksrztx4af2.execute-api.eu-west-1.amazonaws.com/v0/lambda?AccountId=459208450119&Env=Sdlc&ProjectCode=ELZ&Reason=VPC_backoffice-finance--sla3--ews--infra-8015_associated_to_account_workloads-sdlc-int-backoffice&Region=eu-west-1&Requestor=giedrius.guzys&prefix=25"
## "10.98.29.0/25"
## vpc-088051492d8026c26
## python3 signed_request.py PUT "https://ksrztx4af2.execute-api.eu-west-1.amazonaws.com/v0/lambda?Cidr=10.98.29.0/25&VpcId=vpc-088051492d8026c26"

vpc_cidr_cluster = "10.97.23.128/25"

vpc_private_subnets_cluster = ["10.97.23.128/28", "10.97.23.144/28", "10.97.23.160/28", "10.97.23.176/28", "10.97.23.192/28", "10.97.23.208/28"]

## EC2--------------------------------------------------------------------------

ami_master = "ami-0f0540175d0e2c28f" #"ami-03ee68e5017554ba8"

