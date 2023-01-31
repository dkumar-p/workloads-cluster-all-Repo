locals {
  lb_netwrking = format("%s%s%s%s", "C", upper(var.tags["ib:resource:letter-ev"]), "AME2IDNLB", "00019")
}

module "lb_netwrking" {

  providers = {
    aws = aws.networking
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-alb-module?ref=v6.6.1"

  name = local.lb_netwrking

  load_balancer_type = "network"
  internal           = true

  vpc_id = data.terraform_remote_state.networking.outputs.transit_vpc_id

  subnet_mapping = [
    {
      subnet_id            = element(data.terraform_remote_state.networking.outputs.transit_private_subnets, 2)
      private_ipv4_address = "100.64.8.181"
    },
    {
      subnet_id            = element(data.terraform_remote_state.networking.outputs.transit_private_subnets, 3)
      private_ipv4_address = "100.64.12.181"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 8080
      protocol           = "TCP"
      target_group_index = 1
    },
    {
      port               = 8009
      protocol           = "TCP"
      target_group_index = 2
    }
  ]

  /*   https_listeners = [
    {
      port               = 8443
      protocol           = "TLS"
      certificate_arn    = "arn:aws:iam::XXXXXXXXXXXX:server-certificate/XXXXXXXX"
      target_group_index = 4
    },
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = "arn:aws:iam::XXXXXXXXXXXX:server-certificate/XXXXXXXX"
      target_group_index = 5
    }
  ] */

  target_groups = [
    {
      name             = "${local.lb_netwrking}-HTTP"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "ip"
      targets = [
        {
          target_id         = "10.98.141.197"
          port              = 80
          availability_zone = "eu-west-1a"
        },
        {
          target_id         = "10.98.141.213"
          port              = 80
          availability_zone = "eu-west-1b"
        }
      ]
    },
    {
      name             = "${local.lb_netwrking}-8080"
      backend_protocol = "TCP"
      backend_port     = 8080
      target_type      = "ip"
      targets = [
        {
          target_id         = "10.98.141.197"
          port              = 8080
          availability_zone = "eu-west-1a"
        },
        {
          target_id         = "10.98.141.213"
          port              = 8080
          availability_zone = "eu-west-1b"
        }
      ]
    },
    {
      name             = "${local.lb_netwrking}-8009"
      backend_protocol = "TCP"
      backend_port     = 8009
      target_type      = "ip"
      targets = [
        {
          target_id         = "10.98.141.197"
          port              = 8009
          availability_zone = "eu-west-1a"
        },
        {
          target_id         = "10.98.141.213"
          port              = 8009
          availability_zone = "eu-west-1b"
        }
      ]
    },

    /* {
      name             = "${local.name_lb_nlb}-8443"
      backend_protocol = "TCP"
      backend_port     = 8443
      target_type      = "ip"
      targets = [
        {
          target_id         = "10.98.13.197"
          port              = 8443
          availability_zone = "eu-west-1a"
        },
        {
          target_id         = "10.98.13.213"
          port              = 8443
          availability_zone = "eu-west-1b"
        }
      ]
    },
    {
      name             = "${local.name_lb_nlb}-443"
      backend_protocol = "TCP"
      backend_port     = 443
      target_type      = "ip"
      targets = [
        {
          target_id         = "10.98.13.197"
          port              = 443
          availability_zone = "eu-west-1a"
        },
        {
          target_id         = "10.98.13.213"
          port              = 443
          availability_zone = "eu-west-1b"
        }
      ]
    } */
  ]

  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = local.lb_netwrking
    },
    {
      "Name" = local.lb_netwrking
    },
    {
      "ib:resource:application" = "SEG003/PDE_WS/EXP014-80"
    }
  )
}
