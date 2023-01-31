resource "aws_cloudwatch_event_rule" "eventbrige-peoplesoft_cnx_propierties" {
  provider    = aws.prodbackoffice
  name        = "Rule_eventbrige-peoplesoft_cnx_propierties"
  description = "Event for datasource peoplesoft to s3"
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
      "key": ["Peoplesoft/cnx.properties"]
    }
  }
}
EOF
  tags          = var.tags
}


resource "aws_cloudwatch_event_target" "eventbrige-peoplesoft_cnx_propierties" {
  provider  = aws.prodbackoffice
  target_id = "Target_Datasource_peoplesoft_cnx_propierties"
  arn       = "arn:aws:ssm:eu-west-1::document/AWS-RunShellScript"
  rule      = aws_cloudwatch_event_rule.eventbrige-peoplesoft_cnx_propierties.name
  role_arn  = aws_iam_role.eventbrige-peoplesoft.arn
  input     = "{\"commands\":[\"bash /wl_config/config-app.sh iberia-configs-files-apps-production-backoffice Peoplesoft/cnx.properties /wl_internet/PeopleSoft/apli/config/cnx.properties\"]}{\"workingdirectory\":[\"wl_config\"]}{\"executiontimeout\":[\"1000\"]}"

  run_command_targets {
    key    = "tag:ib:resource:environment"
    values = ["prod"]
  }


}
