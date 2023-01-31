locals {
  name_lb_nlb = format("%s%s%s%s", "C", upper(var.tags["ib:resource:letter-ev"]), "AME2IDNLB", "00016")
}

module "lb-nlb" {

  providers = {
    aws = aws.prodbackoffice
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-alb-module?ref=v6.6.1"

  name = local.name_lb_nlb

  load_balancer_type = "network"
  internal           = true

  vpc_id = module.vpc-Cluster.vpc_id

  subnet_mapping = [
    {
      subnet_id            = element(module.vpc-Cluster.private_subnets, 4)
      private_ipv4_address = "10.97.23.196"
    },
    {
      subnet_id            = element(module.vpc-Cluster.private_subnets, 5)
      private_ipv4_address = "10.97.23.213"
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
      name             = "${local.name_lb_nlb}-HTTP"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "alb"
      targets = [
        {
          target_id = module.lb-alb.lb_id
          port      = 80
        }
      ]
    },
    {
      name             = "${local.name_lb_nlb}-80"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "alb"
      targets = [
        {
          target_id = module.lb-alb.lb_id
          port      = 80
        }
      ]
    },
    {
      name             = "${local.name_lb_nlb}-80-2"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "alb"
      targets = [
        {
          target_id = module.lb-alb.lb_id
          port      = 80
        }
      ]
    },

    /* {
      name             = "${local.name_lb_nlb}-8443"
      backend_protocol = "TCP"
      backend_port     = 8443
      target_type      = "alb"
      targets = [
        {
          target_id         = module.lb-alb.lb_id
          port              = 8443          
        }
      ]
    },
    {
      name             = "${local.name_lb_nlb}-443"
      backend_protocol = "TCP"
      backend_port     = 443
      target_type      = "alb"
      targets = [
        {
          target_id         = module.lb-alb.lb_id
          port              = 443          
        }
      ]
    } */
  ]

  tags = merge(var.tags,
    {
      "ib:resource:name" = local.name_lb_nlb
    },
    {
      "Name" = local.name_lb_nlb
    },
    {
      "ib:resource:application" = "SEG003/Portal del Empleado-PDE"
    }
  )

}
