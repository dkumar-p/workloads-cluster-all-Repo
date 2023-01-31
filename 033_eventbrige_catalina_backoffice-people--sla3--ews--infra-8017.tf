resource "aws_cloudwatch_event_rule" "catalina-sla3--ews--infra-8017" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige_catalina-sla3-ews-infra-8017"
  description = "Event for datasource backoffice-people--sla3--ews--infra-8017 to s3"
  role_arn    = aws_iam_role.eventbrige-sla3--ews--infra-8017.arn

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["iberia-configs-files-apps-production-backoffice"]
    },
    "object": {
      "key": ["Catalina/backoffice-people--sla3--ews--infra-8017/catalina.sh"]
    }
  }
}
EOF
  tags          = var.tags
}


resource "aws_cloudwatch_event_target" "catalina-sla3--ews--infra-8017" {
  provider  = aws.prodbackoffice
  target_id = "Target_Catalina_sla3-ews-infra-8017"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.catalina-sla3--ews--infra-8017.name
  role_arn  = aws_iam_role.eventbrige-sla3--ews--infra-8017.arn
  input     = "{\"commands\":[\"bash /wl_config/config-app.sh iberia-configs-files-apps-production-backoffice Catalina/backoffice-people--sla3--ews--infra-8017/catalina.sh ${var.JBOSS_HOME}/bin/catalina.sh\"]}{\"workingdirectory\":[\"wl_config\"]}{\"executiontimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["backoffice-people--sla3--ews--infra-8017"]
  }


}
