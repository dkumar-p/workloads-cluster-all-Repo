tags = {
  "company"                      = "iberia"
  "delete_after"                 = "never"
  "environment"                  = "prod"
  "typeproject"                  = "infra-common"
  "owner"                        = "cdc-nordcloud"
  "project"                      = "iberia"
  "sponsor"                      = "iberia"
  "terraform"                    = "true"
  "ib:resource:op-co-code"       = "ib"
  "group:component-grouping"     = "software-engineering--workloads-prod-backoffice--infra"
  "ib:component:repo"            = "software-engineering--workloads-prod-backoffice--infra"
  "ib:resource:environment-type" = "prod"
  "ib:resource:environment"      = "prod"
  "ib:account:environment"       = "prod"
  "ib:account:short_name"        = "wspbackoffice"
  "ib:account:name"              = "workloads-prod-backoffice"
  "ib:resource:business-domain"  = "i.e"
  "ib:resource:business-service" = "i.e"
  "ib:account:service-offering"  = "i.e"
  "ib:resource:letter-ev"        = "p"
}

compute-tags = {
  "ib:resource:type:backup"  = "true"
  "ib:resource:monitoring"   = "true"
  "ib:resource:environment"  = "prod"
  "group:component-grouping" = "software-engineering--workloads-prod-backoffice--infra"
  "ib:resource:application"  = "common-services"
  #"ib:resource:apptype"      = ""
  "ib:account:name"       = "workloads-prod-backoffice"
  "ib:resource:letter-ev" = "p"
}

account_number = "772838718480"
#main_profile                 = "aws-iberia-sso-workloads-prod-backoffice"
#networking_profile           = "aws-iberia-sso-networking"
#globalsharedservices_profile = "aws-iberia-sso-globalsharedservices"
#gccaddress_profile           = "aws-iberia-sso-gccaddress"

## VPC account -----------------------------------------------------------------
vpc_name_account = ""

vpc_cidr_account = ""

vpc_public_subnets_account = []

vpc_private_subnets_account = []

## VPC route53 -----------------------------------------------------------------

vpc_cidr_route53 = "10.97.13.80/28"

## VAULT BACKUP-----------------------------------------------------------------
create_vault = true
