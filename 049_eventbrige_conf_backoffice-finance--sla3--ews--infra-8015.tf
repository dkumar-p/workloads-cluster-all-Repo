resource "aws_cloudwatch_event_rule" "conf-sla3--ews--infra-8015" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige_conf-sla3-ews-infra-8015"
  description = "Event for conf backoffice-finance--sla3--ews--infra-8015 to s3"
  role_arn    = aws_iam_role.eventbrige-sla3--ews--infra-8015.arn

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["iberia-configs-files-apps-production-backoffice"]
    },
    "object": {
      "key": ["Conf/backoffice-finance--sla3--ews--infra-8015/server.xml"]
    }
  }
}
EOF
  tags          = var.tags
}


resource "aws_cloudwatch_event_target" "conf-sla3--ews--infra-8015" {
  provider  = aws.prodbackoffice
  target_id = "Target_Conf_sla3-ews-infra-8015"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.conf-sla3--ews--infra-8015.name
  role_arn  = aws_iam_role.eventbrige-sla3--ews--infra-8015.arn
  input     = "{\"commands\":[\"bash /wl_config/config-app.sh iberia-configs-files-apps-production-backoffice Conf/backoffice-finance--sla3--ews--infra-8015/server.xml /opt/jws-5.6/tomcat/conf/server.xml \"]}{\"workingDirectory\":[\"wl_config\"]}{\"executionTimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["backoffice-finance--sla3--ews--infra-8015"]
  }


}
