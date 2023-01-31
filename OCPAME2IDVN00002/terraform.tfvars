tags = {
  company                        = "iberia"
  delete_after                   = "never"
  environment                    = "prod"
  owner                          = "cdc-nordcloud"
  project                        = "iberia"
  typeproject                    = "infra-common"
  sponsor                        = "iberia"
  terraform                      = "true"
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

tags_SNS = {
  "company"                      = "iberia"
  "delete_after"                 = "Never"
  "environment"                  = "prod"
  "typeproject"                  = "infra-common"
  "owner"                        = "cdc-nordcloud"
  "project"                      = "iberia"
  "sponsor"                      = "iberia"
  "terraform"                    = "true"
  "ib:resource:op-co-code"       = "ib"
  "ib:resource:application"      = "con006"
  "ib:resource:environment"      = "prod"
  "ib:account:environment"       = "prod"
  "ib:account:short_name"        = "wpbackoffice"
  "ib:account:name"              = "workloads-prod-backoffice"
  "ib:resource:business-domain"  = "Central Services"
  "ib:resource:business-service" = "i.e"
  "ib:account:service-offering"  = "i.e"
  "ib:resource:letter-ev"        = "p"

}

account_number = "772838718480"
main_profile   = "aws-iberia-sso-workloads-prod-backoffice"
#globalsharedservices_profile = "aws-iberia-sso-globalsharedservices"
#networking_profile           = "aws-iberia-sso-networking"
monitoring_profile = "aws-iberia-sso-monitoring"


## VPC -------------------------------------------------------------------------
## vpc_name_dscommon         = "CPAME2IDVN00001"
## vpc_name_dscommon         = "CUAME2IDVN00001"
## vpc_name_dscommon         = "CPAME2IDVN00001"
vpc_name_dscommon = "OCPAME2IDVN00002"


vpc_cidr_dscommon             = "10.97.48.0/21"
vpc_private_subnets_dscommon  = ["10.97.48.0/25", "10.97.48.128/25", "10.97.49.0/25"]
vpc_database_subnets_dscommon = ["10.97.49.128/25", "10.97.50.0/25", "10.97.50.128/25"]