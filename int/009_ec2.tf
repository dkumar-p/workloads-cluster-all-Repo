locals {
  name_sg    = format("%s%s%s%s", "ov", var.tags["ib:resource:letter-ev"], "ame2idsg", "00016")
  ec2_name_1 = format("%s%s%s%s", "xc", var.tags["ib:resource:letter-ev"], "amidas", "00016")
  #kms_ebs_id = data.terraform_remote_state.workloads-sdlc-int-backoffice.outputs.kms_ebs_id

}

module "ec2_instance_1" {

  providers = {
    aws = aws.intbackoffice
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-ec2-instance-module?ref=v3.3.0"
  #version = "~> 3.0"

  name = local.ec2_name_1

  ami                    = var.ami_master
  instance_type          = var.ec2_type
  key_name               = "ec2_apps_key_pair"
  monitoring             = false
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]
  subnet_id              = element(module.vpc-Cluster.private_subnets, 2)

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted             = true
      volume_type           = "gp3"
      volume_size           = 40
      delete_on_termination = true
      tags = merge(var.tags, var.compute-tags,
        {
          "ib:resource:name" = local.ec2_name_1
        },
        {
          "Name" = local.ec2_name_1
        },
      )
    },
  ]

  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = file("backoffice-finance--sla3--ews--infra-8015.sh")


  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = local.ec2_name_1
    },
    {
      "Name" = local.ec2_name_1
    }
  )
}


module "security_group_ec2" {

  providers = {
    aws = aws.intbackoffice
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-security-group-module?ref=v4.7.0"

  name        = local.name_sg
  description = "Security group for usage with EC2 instance SEG003 APP"
  vpc_id      = module.vpc-Cluster.vpc_id

  ingress_cidr_blocks = ["10.96.0.0/14"]
  ingress_rules       = ["ssh-tcp"]

  egress_rules = ["all-all"]

  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = local.name_sg
    },
    {
      "Name" = local.name_sg
    }
  )
}


resource "aws_security_group_rule" "port_389" {
  provider = aws.intbackoffice

  type = "ingress"

  from_port = 389

  to_port = 389

  protocol = "tcp"

  cidr_blocks = ["172.21.252.21/32", "172.21.252.28/32"]

  security_group_id = module.security_group_ec2.security_group_id

}



resource "aws_security_group_rule" "port_9006" {
  provider = aws.intbackoffice

  type = "ingress"

  from_port = 9006

  to_port = 9006

  protocol = "tcp"

  cidr_blocks = ["192.168.26.32/32", "192.168.26.31/32"]

  security_group_id = module.security_group_ec2.security_group_id

}

resource "aws_security_group_rule" "port_443" {
  provider = aws.intbackoffice

  type = "ingress"

  from_port = 443

  to_port = 443

  protocol = "tcp"

  cidr_blocks = ["10.96.0.0/14", "172.21.0.0/16", "172.22.0.0/16"]

  security_group_id = module.security_group_ec2.security_group_id

}



resource "aws_security_group_rule" "port_8080" {
  provider = aws.intbackoffice

  type = "ingress"

  from_port = 8080

  to_port = 8080

  protocol = "tcp"

  cidr_blocks = ["10.96.0.0/14", "172.21.0.0/16", "172.22.0.0/16"]

  security_group_id = module.security_group_ec2.security_group_id

}



resource "aws_security_group_rule" "port_9990" {
  provider = aws.intbackoffice

  type = "ingress"

  from_port = 9990

  to_port = 9990

  protocol = "tcp"

  cidr_blocks = ["10.96.0.0/14"]

  security_group_id = module.security_group_ec2.security_group_id

}





resource "aws_security_group_rule" "port_8443" {
  provider = aws.intbackoffice

  type = "ingress"

  from_port = 8443

  to_port = 8443

  protocol = "tcp"

  cidr_blocks = ["10.96.0.0/14"]

  security_group_id = module.security_group_ec2.security_group_id

}



resource "aws_security_group_rule" "icmp" {
  provider = aws.intbackoffice

  type = "ingress"

  from_port = -1

  to_port = -1

  protocol = "icmp"

  cidr_blocks = ["10.96.0.0/14", "172.21.0.0/16", "172.22.0.0/16", "192.168.0.0/16"]

  security_group_id = module.security_group_ec2.security_group_id

}



resource "aws_security_group_rule" "self" {
  provider = aws.intbackoffice

  type = "ingress"

  from_port = 0

  to_port = 0

  protocol = -1

  self = true

  security_group_id = module.security_group_ec2.security_group_id

}
