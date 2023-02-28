locals {
  nane_vpce_s3     = format("%s%s%s-%s-%s", "oc", var.tags["ib:resource:letter-ev"], "ame2-vpce", var.tags["group:component-grouping"], "s3")
  name_vpc_cluster = format("%s%s%s-%s-%s", "C", upper(var.tags["ib:resource:letter-ev"]), "AME2IDVN", var.tags["group:component-grouping"], "00001")
}

module "vpc-Cluster" {

  providers = {
    aws = aws.intbackoffice
  }

  #source  = "terraform-aws-modules/vpc/aws"
  #version = "3.11.0"
  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-vpc-module?ref=v3.11.0"

  name                 = local.name_vpc_cluster
  cidr                 = var.vpc_cidr_cluster
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets_cluster

  manage_default_security_group  = true
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
      "ib:resource:name" = local.name_vpc_cluster
    },
    {
      "Name" = format("%s-%s", local.name_vpc_cluster, "flow-logs")
    }
  )

  tags = merge(var.tags,
    {
      "ib:resource:name" = local.name_vpc_cluster
    }
  )
}

##resource only for transit-specific subnets that have the /28 netmask, which are placed first and second in the list. 
##Each VPC that is created must have two / 28 Subnets dedicated for transit, so this element must be created for each vpc that is created
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-Cluster" {
  provider           = aws.intbackoffice
  subnet_ids         = [element(module.vpc-Cluster.private_subnets, 0), element(module.vpc-Cluster.private_subnets, 1)]
  transit_gateway_id = data.terraform_remote_state.networking.outputs.tgw_iberia_id
  vpc_id             = module.vpc-Cluster.vpc_id
}

## Expample routes for route tables to all subnets
resource "aws_route" "route-subnet-0" {
  provider               = aws.intbackoffice
  for_each               = toset(module.vpc-Cluster.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.terraform_remote_state.networking.outputs.tgw_iberia_id
  depends_on = [
    module.vpc-Cluster, aws_ec2_transit_gateway_vpc_attachment.vpc-Cluster
  ]
}

##VPCE S3 ONLY VPC COMUN ACCOUNT------------------------------------------------
resource "aws_vpc_endpoint" "vpce-s3-transit" {
  provider          = aws.intbackoffice
  vpc_id            = module.vpc-Cluster.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.eu-west-1.s3"
  route_table_ids   = module.vpc-Cluster.private_route_table_ids
  tags = merge(var.tags, {

    name = local.nane_vpce_s3
    }
  )

}
    

#endpoint ssmendpoint
resource "aws_vpc_endpoint" "ssm_endpoint" {
  provider            = aws.precommercial
  subnet_ids          = [element(module.exadata_vpc.private_subnets, 0), element(module.exadata_vpc.private_subnets, 1)]
  vpc_id              = module.exadata_vpc.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.eu-west-1.ssm"
  security_group_ids  = [aws_security_group.allow_tls.id]
  private_dns_enabled = true
  tags = merge(var.tags, {
    Name = "${var.name_vpc_cluster}_ssm-endpoint"
    }
  )
}


resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  provider            = aws.precommercial
  subnet_ids          = [element(module.exadata_vpc.private_subnets, 0), element(module.exadata_vpc.private_subnets, 1)]
  vpc_id              = module.exadata_vpc.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.eu-west-1.ssmmessages"
  security_group_ids  = [aws_security_group.allow_tls.id]
  private_dns_enabled = true
  tags = merge(var.tags, {
    Name = "${var.name_vpc_cluster}_ssmmessages_endpoint"
    }
  )
}
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  provider            = aws.precommercial
  subnet_ids          = [element(module.exadata_vpc.private_subnets, 0), element(module.exadata_vpc.private_subnets, 1)]
  vpc_id              = module.exadata_vpc.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.eu-west-1.ec2messages"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = merge(var.tags, {
    Name = "${var.name_vpc_cluster}_ec2messages_endpoint"
    }
  )
}
