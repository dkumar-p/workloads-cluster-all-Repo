resource "aws_cloudwatch_event_rule" "eventbrige-Swm" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige-Swm"
  description = "Event for datasource Swm to s3"
  role_arn    = aws_iam_role.eventbrige-peoplesoft.arn

  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["iberia-configs-files-apps-production-backoffice"]
    },
    "object": {
      "key": ["Swm/swm-config.xml"]
    }
  }
}
EOF
  tags          = var.tags
}


resource "aws_cloudwatch_event_target" "eventbrige-Swm" {
  provider  = aws.prodbackoffice
  target_id = "Target_Datasource_Swm"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.eventbrige-Swm.name
  role_arn  = aws_iam_role.eventbrige-peoplesoft.arn
  input     = "{\"commands\":[\"bash /wl_config/config-app.sh iberia-configs-files-apps-production-backoffice Swm/swm-config.xml /wl_internet/swm/apli/config/swm-config.xml\"]}{\"workingdirectory\":[\"wl_config\"]}{\"executiontimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:ib:resource:environment"
    values = ["prod"]
  }


}
