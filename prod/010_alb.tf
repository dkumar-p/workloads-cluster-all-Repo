locals {
  name_lb_alb = format("%s%s%s%s", "C", upper(var.tags["ib:resource:letter-ev"]), "AME2IDLB", "00016")
}

module "lb-alb" {

  providers = {
    aws = aws.prodbackoffice
  }

  source = "git@github.com:Iberia-Ent/software-engineering--iac-terraform-aws-alb-module?ref=v6.6.1"

  name = local.name_lb_alb

  load_balancer_type = "application"
  internal           = true

  vpc_id = module.vpc-Cluster.vpc_id

  subnets = [element(module.vpc-Cluster.private_subnets, 2), element(module.vpc-Cluster.private_subnets, 3)]

  security_groups                  = [module.security_group_ec2.security_group_id]
  idle_timeout                     = 300
  enable_cross_zone_load_balancing = true

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 8080
      protocol           = "HTTP"
      target_group_index = 1
    },
    {
      port               = 8009
      protocol           = "HTTP"
      target_group_index = 2
    }
  ]

  /*   https_listeners = [
    {
      port               = 8443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::XXXXXXXXXXXX:server-certificate/XXXXXXXX"
      target_group_index = 4
    },
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::XXXXXXXXXXXX:server-certificate/XXXXXXXX"
      target_group_index = 5
    }
  ] */

  target_groups = [
    {
      name             = "${local.name_lb_alb}-HTTP"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
    },
    {
      name             = "${local.name_lb_alb}-80"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
    },
    {
      name             = "${local.name_lb_alb}-80-2"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
    },

    /* {
      name             = "${local.name_lb_alb}-8443"
      backend_protocol = "HTTPS"
      backend_port     = 8443
      target_type      = "instance"
      targets = [
        {
          target_id         = module.ec2_instance_1.id
          port              = 8443          
        }
      ]
    },
    {
      name             = "${local.name_lb_alb}-443"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
      targets = [
        {
          target_id         = module.ec2_instance_1.id
          port              = 443          
        }
      ]
    } */
  ]

  tags = merge(var.tags,
    {
      "ib:resource:name" = local.name_lb_alb
    },
    {
      "Name" = local.name_lb_alb
    },
    {
      "ib:resource:application" = "SEG003/Portal del Empleado-PDE"
    }
  )

}
