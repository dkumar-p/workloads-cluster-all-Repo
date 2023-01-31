resource "aws_cloudwatch_event_rule" "eventbrige-update-file-sla3--ews--8025--infra" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige_update-file-sla3--ews--8025--infra"
  description = "Event for update-file backoffice-finance--sla3--ews--8025--infra to s3"
  role_arn    = aws_iam_role.eventbrige-sla3--ews--8025--infra.arn

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["iberia-configs-files-apps-production-backoffice"]
    },
    "object": {
      "key": ["Etc/backoffice-finance--sla3--ews--8025--infra/hosts"]
    }
  }
}
EOF
  tags          = var.tags
}

resource "aws_cloudwatch_event_target" "eventbrige-update-file-sla3--ews--8025--infra" {
  provider  = aws.prodbackoffice
  target_id = "Target_update-file_sla3--ews--8025--infra"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.eventbrige-update-file-sla3--ews--8025--infra.name
  role_arn  = aws_iam_role.eventbrige-sla3--ews--8025--infra.arn
  input     = "{\"commands\":[\"bash /wl_config/update-file.sh iberia-configs-files-apps-production-backoffice Etc/backoffice-finance--sla3--ews--8025--infra/hosts /etc/hosts\"]}{\"workingDirectory\":[\"wl_config\"]}{\"executionTimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["backoffice-finance--sla3--ews--8025--infra"]
  }

}
