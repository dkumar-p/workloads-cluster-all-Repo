resource "aws_cloudwatch_event_rule" "standalone_eventbrige-sla3--eap--infra-8004" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige_Standalone-sla3-eap-infra-8004"
  description = "Event for Standalone backoffice-people--sla3--eap--infra-8004 to s3"
  role_arn    = aws_iam_role.eventbrige-sla3--eap--infra-8004.arn

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["iberia-configs-files-apps-production-backoffice"]
    },
    "object": {
      "key": ["Standalone/backoffice-people--sla3--eap--infra-8004/standalone.conf"]
    }
  }
}
EOF
  tags          = var.tags
}


resource "aws_cloudwatch_event_target" "standalone_eventbrige-sla3--eap--infra-8004" {
  provider  = aws.prodbackoffice
  target_id = "Target_Standalone_sla3-eap-infra-8004"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.standalone_eventbrige-sla3--eap--infra-8004.name
  role_arn  = aws_iam_role.eventbrige-sla3--eap--infra-8004.arn
  input     = "{\"commands\":[\"bash /wl_config/config-app.sh iberia-configs-files-apps-production-backoffice Standalone/backoffice-people--sla3--eap--infra-8004/standalone.conf ${var.JBOSS_HOME_EAP}/bin/standalone.conf\"]}{\"workingdirectory\":[\"wl_config\"]}{\"executiontimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["backoffice-people--sla3--eap--infra-8004"]
  }


}
