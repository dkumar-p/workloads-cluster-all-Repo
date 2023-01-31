resource "aws_cloudwatch_event_rule" "eventbrige-update-file-sla3--ews--infra-8112" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige_update-file-sla3-ews-infra-8112"
  description = "Event for update-file backoffice-people--sla3--ews--infra-8112 to s3"
  role_arn    = aws_iam_role.eventbrige-sla3--ews--infra-8112.arn

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["iberia-configs-files-apps-production-backoffice"]
    },
    "object": {
      "key": ["Etc/backoffice-people--sla3--ews--infra-8112/hosts"]
    }
  }
}
EOF
  tags          = var.tags
}

resource "aws_cloudwatch_event_target" "eventbrige-update-file-sla3--ews--infra-8112" {
  provider  = aws.prodbackoffice
  target_id = "Target_update-file_sla3-ews-infra-8112"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.eventbrige-update-file-sla3--ews--infra-8112.name
  role_arn  = aws_iam_role.eventbrige-sla3--ews--infra-8112.arn
  input     = "{\"commands\":[\"bash /wl_config/update-file.sh iberia-configs-files-apps-production-backoffice Etc/backoffice-people--sla3--ews--infra-8112/hosts /etc/hosts\"]}{\"workingDirectory\":[\"wl_config\"]}{\"executionTimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["backoffice-people--sla3--ews--infra-8112"]
  }

}
