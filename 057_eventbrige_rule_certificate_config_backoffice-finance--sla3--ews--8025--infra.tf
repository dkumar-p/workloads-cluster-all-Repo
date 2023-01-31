resource "aws_cloudwatch_event_rule" "eventbrige-certificate-config-sla3--ews--8025--infra" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige_Certificate_config-sla3--ews--8025--infra"
  description = "Event for certificate config backoffice-finance--sla3--ews--8025--infra to s3"
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
      "key": ["Certificates/backoffice-finance--sla3--ews--8025--infra/policies/java.config"]
    }
  }
}
EOF
  tags          = var.tags
}


resource "aws_cloudwatch_event_target" "eventbrige-certificate-config-sla3--ews--8025--infra" {
  provider  = aws.prodbackoffice
  target_id = "Target_Certificate-config_sla3--ews--8025--infra"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.eventbrige-certificate-config-sla3--ews--8025--infra.name
  role_arn  = aws_iam_role.eventbrige-sla3--ews--8025--infra.arn
  input     = "{\"commands\":[\"bash /wl_config/config-app.sh iberia-configs-files-apps-production-backoffice Certificates/backoffice-finance--sla3--ews--8025--infra/policies/java.config /etc/crypto-policies/back-ends/java.config\"]}{\"workingdirectory\":[\"wl_config\"]}{\"executiontimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["backoffice-finance--sla3--ews--8025--infra"]
  }


}
