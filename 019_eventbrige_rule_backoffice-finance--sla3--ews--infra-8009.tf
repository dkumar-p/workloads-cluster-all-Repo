resource "aws_cloudwatch_event_rule" "eventbrige-sla3--ews--infra-8009" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige_Datasource-sla3-ews-infra-8009"
  description = "Event for datasource backoffice-finance--sla3--ews--infra-8009 to s3"
  role_arn    = aws_iam_role.eventbrige-sla3--ews--infra-8009.arn

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["iberia-configs-files-apps-production-backoffice"]
    },
    "object": {
      "key": ["Datasource/backoffice-finance--sla3--ews--infra-8009/context.xml"]
    }
  }
}
EOF
  tags          = var.tags
}


resource "aws_cloudwatch_event_target" "eventbrige-sla3--ews--infra-8009" {
  provider  = aws.prodbackoffice
  target_id = "Target_Datasource_sla3-ews-infra-8009"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.eventbrige-sla3--ews--infra-8009.name
  role_arn  = aws_iam_role.eventbrige-sla3--ews--infra-8009.arn
  input     = "{\"commands\":[\"bash /wl_config/config-app.sh iberia-configs-files-apps-production-backoffice Datasource/backoffice-finance--sla3--ews--infra-8009/context.xml ${var.JBOSS_HOME}/conf/context.xml\"]}{\"workingDirectory\":[\"wl_config\"]}{\"executionTimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["backoffice-finance--sla3--ews--infra-8009"]
  }


}