resource "aws_iam_role" "iam_for_lambda-Ec2ConfigureCloudwatchAgent" {
  name               = "AWS_lambdaEc2ConfigureCloudwatchAgent-Role"
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

### SSM and EC2 policies
resource "aws_iam_policy" "policy-lambda-ssm-ec2-role" {
  provider    = aws.prodbackoffice
  name        = "aws-lambda-ssm-ec2"
  path        = "/"
  description = "access from lambda to execute commands with ssm and to describe ec2 instances."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeInstanceStatus"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-ssm-ec2-attach-lambda-role" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.iam_for_lambda-Ec2ConfigureCloudwatchAgent.name
  policy_arn = aws_iam_policy.policy-lambda-ssm-ec2-role.arn
}

### Basic Execution Role - Logs policies
resource "aws_iam_policy" "policy-lambda-basic-execution-Ec2ConfigureCloudwatchAgent-role" {
  provider    = aws.prodbackoffice
  name        = "aws-lambda-basic-execution-ec2-configure-cloudwatch-agent"
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
          "arn:aws:logs:eu-west-1:${var.account_number}:log-group:/aws/lambda/aws-ec2-configure-CloudWatchAgent:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-basic-execution-attach-lambda-Ec2ConfigureCloudwatchAgent-role" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.iam_for_lambda-Ec2ConfigureCloudwatchAgent.name
  policy_arn = aws_iam_policy.policy-lambda-basic-execution-Ec2ConfigureCloudwatchAgent-role.arn
}


### Lambda invoke function destination policies
##### Cambiar Resource destiny poner el arn de la otra lambda generada en terraform
resource "aws_iam_policy" "policy-lambda-invoke-destination-function-execution-role" {
  provider    = aws.prodbackoffice
  name        = "aws-lambda-invoke-destination-function"
  path        = "/"
  description = "access from lambda to invoke another lambda function"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "lambda:InvokeFunction",
          "lambda:InvokeAsync"
        ],
        Resource : aws_lambda_function.lambda_function-create-alarms-dashboards-cloudwatch-in-monitoring.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-basic-execution-attach-lambda-invoke-destination-Ec2ConfigureCloudwatchAgent-role" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.iam_for_lambda-Ec2ConfigureCloudwatchAgent.name
  policy_arn = aws_iam_policy.policy-lambda-invoke-destination-function-execution-role.arn
}




resource "aws_lambda_function" "lambda_function-ec2-configure-CloudWatchAgent" {
  provider         = aws.prodbackoffice
  function_name    = "aws-ec2-configure-CloudWatchAgent"
  description      = "Function launch by EB rule Rule_ec2_change_status_running_terminate. When an EC2 state change to Running, it installs and configure CW Agent in the instance if it is correctly tagged. And Invoke lambda aws-create-alarms-dashboards-cloudwatch-in-monitoring"
  filename         = "${path.module}/src/aws-ec2-configure-CloudWatchAgent.zip"
  source_code_hash = filebase64sha256("${path.module}/src/aws-ec2-configure-CloudWatchAgent.zip")
  role             = aws_iam_role.iam_for_lambda-Ec2ConfigureCloudwatchAgent.arn
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  timeout          = 900
  tags             = var.tags
}


