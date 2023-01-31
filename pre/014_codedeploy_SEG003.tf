locals {
  code_deploy_apps_SEG003 = ["AutenticationService", "MOD_Autenticacion", "MOD_Captcha", "MOD_Cifrado", "MOD_Conexion", "MOD_PDTLDAP", "MOD_Validacion", "pascifra"]
  app_group_SEG003        = "SEG003"
}

resource "aws_codedeploy_app" "SEG003" {
  provider         = aws.prebackoffice
  for_each         = toset(local.code_deploy_apps_SEG003)
  compute_platform = "Server"
  name             = each.value
}

resource "aws_codedeploy_deployment_config" "SEG003" {
  provider               = aws.prebackoffice
  deployment_config_name = "CodeDeploy.${local.app_group_SEG003}"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}
resource "aws_codedeploy_deployment_group" "SEG003" {
  provider               = aws.prebackoffice
  for_each               = toset(local.code_deploy_apps_SEG003)
  app_name               = aws_codedeploy_app.SEG003[each.value].name
  deployment_group_name  = "${each.value}-${local.app_group_SEG003}"
  service_role_arn       = "arn:aws:iam::${var.account_number}:role/CodeDeployRole"
  deployment_config_name = aws_codedeploy_deployment_config.SEG003.id
  autoscaling_groups     = [aws_autoscaling_group.asg.name]
  /*
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = local.name_ec2
    }
  }
  */
  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
