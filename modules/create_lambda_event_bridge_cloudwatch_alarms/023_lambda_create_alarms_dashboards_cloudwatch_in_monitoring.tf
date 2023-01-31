resource "aws_iam_role" "iam_for_lambda-CreateAlarmsDashboardsCloudwatch_in_Monitoring" {
  name               = "AWS_lambdaCreateAlarmsDashboardsCloudwatch_in_Monitoring-Role"
  provider           = aws.prodbackoffice
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

output "output_iam-role_for_lambda-CreateAlarmsDashboardsCloudwatch_in_Monitoring_arn" {

  value = aws_iam_role.iam_for_lambda-CreateAlarmsDashboardsCloudwatch_in_Monitoring.arn
}




### EC2, CLOUDWATCH, TAG policies
resource "aws_iam_policy" "policy-lambda-ec2-cloudwatch-tag-role" {
  provider    = aws.prodbackoffice
  name        = "aws-lambda-ec2-cloudwatch"
  path        = "/"
  description = "access from lambda to list cloudwatch metrics, to describe ec2 instances and to get arn resources filter by tag"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "cloudwatch:ListMetrics",
          "cloudwatch:PutDashboard",
          "tag:GetResources"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-ec2-cloudwatch-tag-role" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.iam_for_lambda-CreateAlarmsDashboardsCloudwatch_in_Monitoring.name
  policy_arn = aws_iam_policy.policy-lambda-ec2-cloudwatch-tag-role.arn
}

### Asume Role From Monitoring Account policies
resource "aws_iam_policy" "policy-lambda-sts-monitoringaccount-role" {
  provider    = aws.prodbackoffice
  name        = "aws-lambda-sts-monitoringaccount-cloudwatch"
  path        = "/"
  description = "access from lambda to assume role aws-lambdaCreateAlarmsAndDashboardsGetTags-Role from Monitoring Account "

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "sts:AssumeRole",
        Resource : "arn:aws:iam::207656073076:role/aws-lambdaCreateAlarmsAndDashboardsGetTags-Role"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-sts-monitoringaccount-role" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.iam_for_lambda-CreateAlarmsDashboardsCloudwatch_in_Monitoring.name
  policy_arn = aws_iam_policy.policy-lambda-sts-monitoringaccount-role.arn
}


### Basic Execution Role - Logs policies
resource "aws_iam_policy" "policy-lambda-create-alarms-dashboards-basic-execution-role" {
  provider    = aws.prodbackoffice
  name        = "aws-lambda-basic-execution-create-alarms-dashboards-cloudwatch-in-monitoring"
  path        = "/"
  description = "access from lambda to put logs in cloudwatch."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "logs:CreateLogGroup",
        Resource : "arn:aws:logs:eu-west-1:${var.account_number}:*"
      },
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : [
          "arn:aws:logs:eu-west-1:${var.account_number}:log-group:/aws/lambda/aws-create-alarms-dashboards-cloudwatch-in-monitoring:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-basic-create-alarms-dashboards-execution-attach-lambda-role" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.iam_for_lambda-CreateAlarmsDashboardsCloudwatch_in_Monitoring.name
  policy_arn = aws_iam_policy.policy-lambda-create-alarms-dashboards-basic-execution-role.arn
}

resource "aws_lambda_function" "lambda_function-create-alarms-dashboards-cloudwatch-in-monitoring" {
  provider         = aws.prodbackoffice
  function_name    = "aws-create-alarms-dashboards-cloudwatch-in-monitoring"
  description      = "Function invoked by lambda aws-ec2-configure-CloudWatchAgent that creates/deletes in Monitoring Account the alarms of the EC2 instance passed by parameter and makes an update of the CloudWatch Dashboard of the application that the EC2 instance belongs"
  filename         = "${path.module}/src/aws-create-alarms-dashboards-cloudwatch-in--monitoring.zip"
  source_code_hash = filebase64sha256("${path.module}/src/aws-create-alarms-dashboards-cloudwatch-in--monitoring.zip")
  role             = aws_iam_role.iam_for_lambda-CreateAlarmsDashboardsCloudwatch_in_Monitoring.arn
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  timeout          = 900
  tags             = var.tags
}
