resource "aws_cloudwatch_event_rule" "eventbrige-certificate-sla3--ews--8025--infra" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige_certificate-sla3--ews--8025--infra"
  description = "Event for certificate backoffice-finance--sla3--ews--8025--infra to s3"
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
      "key": ["Certificates/backoffice-finance--sla3--ews--8025--infra/certificate.pem"]
    }
  }
}
EOF
  tags          = var.tags
}

resource "aws_cloudwatch_event_target" "eventbrige-certificate-sla3--ews--8025--infra" {
  provider  = aws.prodbackoffice
  target_id = "Target_certificate_sla3--ews--8025--infra"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.eventbrige-certificate-sla3--ews--8025--infra.name
  role_arn  = aws_iam_role.eventbrige-sla3--ews--8025--infra.arn
  input     = "{\"commands\":[\"bash /wl_config/import-certificate.sh iberia-configs-files-apps-production-backoffice Certificates/backoffice-finance--sla3--ews--8025--infra/certificate.pem /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.312.b07-2.el8_5.x86_64/jre/bin/certificate.pem iberiaCert iberiaCert /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.312.b07-2.el8_5.x86_64/jre/lib/security/cacerts changeit\"]}{\"workingDirectory\":[\"wl_config\"]}{\"executionTimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:group:component-grouping"
    values = ["backoffice-finance--sla3--ews--8025--infra"]
  }

}
