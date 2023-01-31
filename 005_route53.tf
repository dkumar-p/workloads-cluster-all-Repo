# Private Hosted Zones GCC Address account
module "phz-gccaddress-workloads-prod-backoffice" {
  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-route53-module.git//modules/zones?ref=v2.4.0"

  providers = {
    aws = aws.gccaddress
  }

  zones = {
    "private-gccaddress.vpc.workloads-prod-backoffice.aws.iberia.es" = {
      # in case than private and public zones with the same domain name
      domain_name = "workloads-prod-backoffice.aws.iberia.es"
      comment     = "PHZ workloads-prod-backoffice.aws.iberia.es"
      vpc = [
        {
          vpc_id = data.terraform_remote_state.gccaddress.outputs.vpc_id
        }
      ]
      tags = var.tags
    }
  }
}

# Private Hosted Zones
module "phz-workloads-prod-backoffice" {
  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-route53-module.git//modules/zones?ref=v2.4.0"
  providers = {
    aws = aws.prodbackoffice
  }
  zones = {
    "private-vpc.workloads-prod-backoffice.aws.iberia.es" = {
      # in case than private and public zones with the same domain name
      domain_name = "workloads-prod-backoffice.aws.iberia.es" #hay que cambiar el dominio el prefijo [accountname] para el propio de la cuenta
      comment     = "PHZ workloads-prod-backoffice.aws.iberia.es"
      vpc = [
        {
          vpc_id = module.vpc-route53-wspbackoffice.vpc_id
        },
        {
          vpc_id = "vpc-06cfb75d1c9f495ee"
        },
        {
          vpc_id = "vpc-03f100404d1593263"
        },
        {
          vpc_id = "vpc-0704dd7e51009d43c"
        },
        {
          vpc_id = "vpc-0aaeca9223c81ffa3"
        },
        {
          vpc_id = "vpc-0eb75247a90c6edb8"
        },
        {
          vpc_id = "vpc-06941661b3e64d8b5"
        },
        {
          vpc_id = "vpc-05b20d95d67e7cde1"
        },
        {
          vpc_id = "vpc-098e37fe7c43fc99e"
        }
      ]
      tags = var.tags
    }
  }
}

resource "aws_route53_vpc_association_authorization" "globalsharedservices" {
  provider = aws.prodbackoffice
  vpc_id   = data.terraform_remote_state.globalsharedservices.outputs.vpc_dns_id
  zone_id  = module.phz-workloads-prod-backoffice.route53_zone_zone_id["private-vpc.workloads-prod-backoffice.aws.iberia.es"]
}

########################### IMPORTANTE #########################################
## Antes de realizar el apply en el terraform en el repo propio de la cuenta hay que hacer los siguiente:

#1.- apply con la creación PHZ (sin el vpc_id de sharedservices sin vpc_id = "vpc-06cfb75d1c9f495ee")

#2.- lanzar comandos AWS CLI:
# aws route53 associate-vpc-with-hosted-zone --hosted-zone-id [ZoneID_ACCOUNT] --vpc VPCRegion=eu-west-1,VPCId=vpc-06cfb75d1c9f495ee --profile=aws-iberia-sso-globalsharedservices

#3.- apply añadiendo la VPC de sharedservices (vpc_id = "vpc-06cfb75d1c9f495ee")

