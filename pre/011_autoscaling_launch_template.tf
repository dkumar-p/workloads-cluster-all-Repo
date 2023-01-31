locals {

  name_sns_asg              = format("%s%s%s%s", "ov", var.tags["ib:resource:letter-ev"], "ame2idsn", "00016")
  name_launch_configuration = format("%s%s%s%s", "ov", var.tags["ib:resource:letter-ev"], "ame2idlc", "00016")
  name_asg                  = format("%s%s%s%s", "ov", var.tags["ib:resource:letter-ev"], "ame2idas", "00016")
  name_ec2                  = format("%s%s%s%s", "xc", var.tags["ib:resource:letter-ev"], "amidas", "00016")
  name_scale_up             = format("%s%s%s%s-%s", "ov", var.tags["ib:resource:letter-ev"], "ame2idae", "00016", "up")
  name_scale_down           = format("%s%s%s%s-%s", "ov", var.tags["ib:resource:letter-ev"], "ame2idae", "00016", "down")

}

## SNS y NOTIFICATIONS----------------------------------------------------------
resource "aws_sns_topic" "asg" {
  provider = aws.prebackoffice
  name     = local.name_sns_asg
  tags = merge(var.tags, {
    Name = local.name_sns_asg
    }
  )
}


data "aws_iam_policy_document" "asg" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }

    resources = [
      "${aws_sns_topic.asg.arn}"
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "asg" {
  provider = aws.prebackoffice
  arn      = aws_sns_topic.asg.arn
  policy   = data.aws_iam_policy_document.asg.json
}


resource "aws_autoscaling_notification" "asg" {
  provider = aws.prebackoffice
  group_names = [
    aws_autoscaling_group.asg.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.asg.arn
}

#-------------------------------------------------------------------------------


# AUTOSCALING GROUP
resource "aws_launch_template" "asg" {
  provider               = aws.prebackoffice
  name                   = local.name_launch_configuration
  instance_type          = var.ec2_type
  key_name               = "ec2_apps_key_pair"
  image_id               = var.ami_master #"ami-0f77bd5e070febbbb"
  user_data              = filebase64("backoffice-finance--sla3--ews--infra-8015.sh")
  ebs_optimized          = true
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 40
    }
  }

  iam_instance_profile {
    name = "AmazonSSMRoleForInstancesQuickSetup"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.tags, var.compute-tags,
      {
        "ib:resource:name" = local.name_launch_configuration
      },
      {
        "Name" = local.name_launch_configuration
      }
    )
  }
  tags = merge(var.tags, var.compute-tags,
    {
      "ib:resource:name" = local.name_launch_configuration
    },
    {
      "Name" = local.name_launch_configuration
    }
  )
}


resource "aws_autoscaling_group" "asg" {
  provider   = aws.prebackoffice
  depends_on = [aws_launch_template.asg]

  name                = local.name_asg
  desired_capacity    = 2
  min_size            = 2
  max_size            = 8
  target_group_arns   = module.lb-alb.target_group_arns
  vpc_zone_identifier = [element(module.vpc-Cluster.private_subnets, 2), element(module.vpc-Cluster.private_subnets, 3)]
  health_check_type   = "EC2"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceCapacity", "GroupPendingCapacity", "GroupMinSize", "GroupMaxSize", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupStandbyCapacity", "GroupTerminatingCapacity", "GroupTerminatingInstances", "GroupTotalCapacity", "GroupTotalInstances"]

  launch_template {
    id      = aws_launch_template.asg.id
    version = aws_launch_template.asg.latest_version
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      "key"                 = "ib:resource:type:backup"
      "value"               = "false"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "Name"
      "value"               = local.name_ec2
      "propagate_at_launch" = true
    },
    {
      "key"                 = "ib:resource:name"
      "value"               = local.name_ec2
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:resource:monitoring"
      "value"               = "false"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:resource:environment"
      "value"               = "pre"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "ib:resource:application"
      "value"               = "SEG003,PDE_WS,EXP014-80"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "group:component-grouping"
      "value"               = "backoffice-finance--sla3--ews--infra-8015"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "ib:resource:apptype"
      "value"               = "ews"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "ib:account:name"
      "value"               = "workloads-sdlc-pre-backoffice"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "ib:resource:letter-ev"
      "value"               = "u"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "company"
      "value"               = "iberia"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "delete_after"
      "value"               = "never"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "environment"
      "value"               = "pre"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "typeproject"
      "value"               = "infra-common"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "owner"
      "value"               = "cdc-nordcloud"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "project"
      "value"               = "iberia"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "sponsor"
      "value"               = "iberia"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "terraform"
      "value"               = "true"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:resource:op-co-code"
      "value"               = "ib"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:account:environment"
      "value"               = "pre"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:account:short_name"
      "value"               = "wsprebackoffice"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:resource:business-domain"
      "value"               = "i.e"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:resource:business-service"
      "value"               = "i.e"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:account:service-offering"
      "value"               = "i.e"
      "propagate_at_launch" = true
    },

    {
      "key"                 = "ib:resource:environment-type"
      "value"               = "pre"
      "propagate_at_launch" = true
    },
  ]
}




## CLOUDWATCH

# scale up alarm
resource "aws_autoscaling_policy" "checkpoint-cpu-policy-up" {
  provider               = aws.prebackoffice
  name                   = local.name_scale_up
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "checkpoint-cpu-alarm-up" {
  provider            = aws.prebackoffice
  alarm_name          = local.name_scale_up
  alarm_description   = "cpu-alarm-asg-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.checkpoint-cpu-policy-up.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "checkpoint-cpu-policy-down" {
  provider               = aws.prebackoffice
  name                   = local.name_scale_down
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "checkpoint-cpu-alarm-down" {
  provider            = aws.prebackoffice
  alarm_name          = local.name_scale_down
  alarm_description   = "cpu-alarm-asg-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "15"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.checkpoint-cpu-policy-down.arn]
}
