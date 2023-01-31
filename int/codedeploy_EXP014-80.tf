locals {
  code_deploy_apps_EXP014-80 = ["componentemultiidiomaapp"]
  app_group_EXP014-80        = "EXP014-80"
}

resource "aws_codedeploy_app" "EXP014-80" {
  provider         = aws.intbackoffice
  for_each         = toset(local.code_deploy_apps_EXP014-80)
  compute_platform = "Server"
  name             = each.value
}

resource "aws_codedeploy_deployment_config" "EXP014-80" {
  provider               = aws.intbackoffice
  deployment_config_name = "CodeDeploy.${local.app_group_EXP014-80}"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

resource "aws_codedeploy_deployment_group" "EXP014-80" {
  provider               = aws.intbackoffice
  for_each               = toset(local.code_deploy_apps_EXP014-80)
  app_name               = aws_codedeploy_app.EXP014-80[each.value].name
  deployment_group_name  = "${each.value}-${local.app_group_EXP014-80}"
  service_role_arn       = "arn:aws:iam::${var.account_number}:role/CodeDeployRole"
  deployment_config_name = aws_codedeploy_deployment_config.EXP014-80.id

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = local.ec2_name_1
    }
  }

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
