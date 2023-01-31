module "vpc-workloads-commercial-common" {
  source               = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-vpc-module?ref=v3.11.0"
  name                 = var.vpc_name_dscommon
  cidr                 = var.vpc_cidr_dscommon
  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_route_table = false

  azs              = var.vpc_azs
  private_subnets  = var.vpc_private_subnets_dscommon
  database_subnets = var.vpc_database_subnets_dscommon

  ### CHANGES START HERE

  # secondary_cidr_blocks = ["100.64.77.0/24"]
  # public_subnets        = ["100.64.77.0/25"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false

  ### CHANGES END HERE

  enable_flow_log                                 = false
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  create_flow_log_cloudwatch_iam_role             = true
  create_flow_log_cloudwatch_log_group            = true
  flow_log_file_format                            = var.flow_log_file_format
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_per_hour_partition                     = true
  flow_log_log_format                             = var.flow_log_log_format

  vpc_flow_log_tags = merge(var.tags,
    {
      "ib:resource:name" = "OCPAME2IDVN00002"
      "Name"             = "OCPAME2IDVN00002-flow-logs"
    }
  )

  tags = merge(var.tags,
    {
      "ib:resource:name" = "OCPAME2IDVN00002"
    }
  )
}



# tgw attachment for IBERIA TGW


resource "aws_ec2_transit_gateway_vpc_attachment" "iberia-tgw-attachement" {
  subnet_ids         = [element(module.vpc-workloads-commercial-common.private_subnets, 0), element(module.vpc-workloads-commercial-common.private_subnets, 1), element(module.vpc-workloads-commercial-common.private_subnets, 2)]
  transit_gateway_id = var.iberia_tgw_id
  vpc_id             = module.vpc-workloads-commercial-common.vpc_id
  tags               = var.tags
}

# routes

resource "aws_route" "lnf-int-default-route" {
  for_each               = toset(module.vpc-workloads-commercial-common.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.iberia_tgw_id
  depends_on = [
    module.vpc-workloads-commercial-common, aws_ec2_transit_gateway_vpc_attachment.iberia-tgw-attachement
  ]
}

#Security group for end points
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc-workloads-commercial-common.vpc_id
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, var.compute-tags, {
    Name = "${var.vpc_name_dscommon}_endpoint-security_group"
    }
  )
}

#endpoints code-------
#endpoiny S3 gateway endpoint
resource "aws_vpc_endpoint" "vpc-s3-transit" {
  vpc_id            = module.vpc-workloads-commercial-common.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.eu-west-1.s3"
  route_table_ids   = module.vpc-workloads-commercial-common.private_route_table_ids
  #private_dns_enabled = true
  tags = merge(var.tags, {
    Name = "${var.vpc_name_dscommon}_s3-endpoint"
    }
  )
}

#endpoint ssmendpoint
resource "aws_vpc_endpoint" "ssm_endpoint" {
  subnet_ids          = [element(module.vpc-workloads-commercial-common.private_subnets, 0), element(module.vpc-workloads-commercial-common.private_subnets, 1), element(module.vpc-workloads-commercial-common.private_subnets, 2)]
  vpc_id              = module.vpc-workloads-commercial-common.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.eu-west-1.ssm"
  security_group_ids  = [aws_security_group.allow_tls.id]
  private_dns_enabled = true
  tags = merge(var.tags, {
    Name = "${var.vpc_name_dscommon}_ssm-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  subnet_ids          = [element(module.vpc-workloads-commercial-common.private_subnets, 0), element(module.vpc-workloads-commercial-common.private_subnets, 1), element(module.vpc-workloads-commercial-common.private_subnets, 2)]
  vpc_id              = module.vpc-workloads-commercial-common.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.eu-west-1.ssmmessages"
  security_group_ids  = [aws_security_group.allow_tls.id]
  private_dns_enabled = true
  tags = merge(var.tags, {
    Name = "${var.vpc_name_dscommon}_ssmmessages_endpoint"
    }
  )
}
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  subnet_ids          = [element(module.vpc-workloads-commercial-common.private_subnets, 0), element(module.vpc-workloads-commercial-common.private_subnets, 1), element(module.vpc-workloads-commercial-common.private_subnets, 2)]
  vpc_id              = module.vpc-workloads-commercial-common.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.eu-west-1.ec2messages"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = merge(var.tags, {
    Name = "${var.vpc_name_dscommon}_ec2messages_endpoint"
    }
  )
}
resource "aws_vpc_endpoint" "ec2_endpoint" {
  subnet_ids          = [element(module.vpc-workloads-commercial-common.private_subnets, 0), element(module.vpc-workloads-commercial-common.private_subnets, 1), element(module.vpc-workloads-commercial-common.private_subnets, 2)]
  vpc_id              = module.vpc-workloads-commercial-common.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.eu-west-1.ec2"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.allow_tls.id]
  tags = merge(var.tags, {
    Name = "${var.vpc_name_dscommon}_ec2_endpoint"
    }
  )
}

/*

/*

# tgw attachment for DIRECTCONNECT TGW

variable "tgw-migration-id" {
  description = "ID of the Temporary Migration TGW ID"
  type        = string
  default     = ""
}

resource "aws_ec2_transit_gateway_vpc_attachment" "migration-tgw-attachement" {
  subnet_ids = [element(module.vpc-deployments-sdlc-common.private_subnets, 1), element(module.vpc-deployments-sdlc-common.private_subnets, 2)]
  #  subnet_ids         = tolist(module.vpc-deployments-sdlc-common.private_subnets)
  transit_gateway_id = var.tgw-migration-id
  vpc_id             = module.vpc-deployments-sdlc-common.vpc_id
  tags               = var.tags
}

# routes

resource "aws_route" "lnf-int-default-route" {
  for_each               = toset(module.vpc-deployments-sdlc-common.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw-migration-id
}

*/