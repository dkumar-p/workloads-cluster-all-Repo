resource "aws_cloudwatch_event_rule" "eventbrige-ec2-change-status" {
  provider    = aws.prodbackoffice
  name        = "Rule_ec2_change_status_running_terminate"
  description = "Event for ec2 instance when its state change to running or terminate"
  #role_arn    = aws_iam_role.eventbrige-sla3--eap--infra-8004.arn

  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["terminated", "running"]
  }
}
EOF
  tags          = var.tags
}


resource "aws_cloudwatch_event_target" "eventbrige-target-lambda" {
  provider  = aws.prodbackoffice
  target_id = "Lambda-Target_ec2_change_status_running_terminate"
  arn       = aws_lambda_function.lambda_function-ec2-configure-CloudWatchAgent.arn
  rule      = aws_cloudwatch_event_rule.eventbrige-ec2-change-status.name


}


resource "aws_lambda_permission" "allow_cloudwatch" {
  provider      = aws.prodbackoffice
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function-ec2-configure-CloudWatchAgent.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eventbrige-ec2-change-status.arn
}

/*
resource "aws_lambda_alias" "allow_cloudwatch_alias" {
  name             = "allow_cloudwatch_alias"
  description      = "Get the last version of lambda function ${aws_lambda_function.lambda_function-ec2-configure-CloudWatchAgent.function_name}"
  function_name    = aws_lambda_function.lambda_function-ec2-configure-CloudWatchAgent.function_name
  function_version = "$LATEST"
}
*/
