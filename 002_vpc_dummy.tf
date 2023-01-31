locals {
  vpc_name_route53 = format("%s%s%s%s", "C", upper(var.tags["ib:resource:letter-ev"]), "AME2IDVN", "00001")
}

module "vpc-route53-wspbackoffice" {
  #source  = "terraform-aws-modules/vpc/aws"
  #version = "3.11.0"
  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-vpc-module.git?ref=v3.11.0"
  providers = {
    aws = aws.prodbackoffice
  }
  name                 = local.vpc_name_route53
  cidr                 = var.vpc_cidr_route53
  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_security_group  = false
  default_security_group_ingress = [{}]
  default_security_group_egress  = [{}]

  enable_flow_log                                 = true
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  create_flow_log_cloudwatch_iam_role             = true
  create_flow_log_cloudwatch_log_group            = true
  flow_log_file_format                            = var.flow_log_file_format
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_per_hour_partition                     = true
  flow_log_log_format                             = var.flow_log_log_format

  vpc_flow_log_tags = merge(var.tags,
    {
      "ib:resource:name" = local.vpc_name_route53
    },
    {
      "Name" = format("%s-%s", local.vpc_name_route53, "flow-logs")
    }
  )

  tags = merge(var.tags,
    {
      "ib:resource:name" = local.vpc_name_route53
    }
  )
}
