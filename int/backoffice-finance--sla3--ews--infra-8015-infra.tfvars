## BACKEND TERRAFORM:
# bucket               = "ocpame2-sb-tfs-459208450119-001"
# dynamodb_table       = "ocpame2-dd-tfs-459208450119-001"


tags = {
  "company"                      = "iberia"
  "delete_after"                 = "never"
  "environment"                  = "int"
  "typeproject"                  = "infra-common"
  "owner"                        = "cdc-nordcloud"
  "project"                      = "iberia"
  "sponsor"                      = "iberia"
  "terraform"                    = "true"
  "ib:resource:op-co-code"       = "ib"
  "group:component-grouping"     = "backoffice-finance--sla3--ews--infra-8015"
  "ib:resource:environment"      = "int"
  "ib:account:environment"       = "int"
  "ib:resource:environment-type" = "int"
  "ib:account:short_name"        = "wsintbackoffice"
  "ib:account:name"              = "workloads-sdlc-int-backoffice"
  "ib:resource:business-domain"  = "i.e"
  "ib:resource:business-service" = "i.e"
  "ib:account:service-offering"  = "i.e"
  "ib:resource:letter-ev"        = "i"
}

compute-tags = {
  "ib:resource:type:backup"  = "false"
  "ib:resource:monitoring"   = "false"
  "ib:resource:environment"  = "int"
  "ib:resource:application"  = "SEG003,PDE_WS,EXP014-80"
  "group:component-grouping" = "backoffice-finance--sla3--ews--infra-8015"
  "ib:resource:apptype"      = "ews"
  "ib:account:name"          = "workloads-sdlc-int-backoffice"
  "ib:resource:letter-ev"    = "i"
}

account_number               = "459208450119"
main_profile                 = "aws-iberia-sso-workloads-sdlc-int-backoffice"
globalsharedservices_profile = "aws-iberia-sso-globalsharedservices"
networking_profile           = "aws-iberia-sso-networking"

## VPC sla3-ews-infra-8015 -----------------------------------------------------------------
## python3 signed_request.py POST "https://ksrztx4af2.execute-api.eu-west-1.amazonaws.com/v0/lambda?AccountId=459208450119&Env=Sdlc&ProjectCode=ELZ&Reason=VPC_backoffice-finance--sla3--ews--infra-8015_associated_to_account_workloads-sdlc-int-backoffice&Region=eu-west-1&Requestor=giedrius.guzys&prefix=25"
## "10.98.29.0/25"
## vpc-088051492d8026c26
## python3 signed_request.py PUT "https://ksrztx4af2.execute-api.eu-west-1.amazonaws.com/v0/lambda?Cidr=10.98.29.0/25&VpcId=vpc-088051492d8026c26"

vpc_cidr_cluster = "10.98.148.0/25"

vpc_private_subnets_cluster = ["10.98.148.0/28", "10.98.148.16/28", "10.98.148.32/28", "10.98.148.48/28", "10.98.148.64/28", "10.98.148.80/28"]

## EC2--------------------------------------------------------------------------

###
### ami_master = "ami-0b75278e49f6f9364"
### Change AMI ID on 06.04.2022 to "ami-03ee68e5017554ba8" by @Javier Buendía Gamboa 

ami_master = "ami-0f0540175d0e2c28f"
ec2_type   = "m5.large"
