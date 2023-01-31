resource "aws_iam_role" "ssm" {
  name     = "AmazonSSMRoleForInstancesQuickSetup"
  provider = aws.prodbackoffice
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "ssm-1" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm-2" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}

resource "aws_iam_role_policy_attachment" "ssm-CWagentServerPolicy" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ssm-profile" {
  provider = aws.prodbackoffice
  name     = "AmazonSSMRoleForInstancesQuickSetup"
  role     = aws_iam_role.ssm.name
}

## CloudWatch logs and metrics policies---------------------------------------
resource "aws_iam_policy" "policy-cloudwatch-logs" {
  provider    = aws.prodbackoffice
  name        = "aws-cloudwatch-PolicyToSendLogs"
  path        = "/"
  description = "access from ec2 instances to send logs to Log-Archive Account"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "sts:AssumeRole"
        ],
        Resource : [
          "arn:aws:iam::${var.logging_account_number}:role/aws-cloudwatch-RoleToReceiveLogs"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-attach-cloudwatch-logs" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.ssm.name
  policy_arn = aws_iam_policy.policy-cloudwatch-logs.arn
}

resource "aws_iam_policy" "policy-cloudwatch-metrics" {
  provider    = aws.prodbackoffice
  name        = "aws-cloudwatch-PolicyToSendMetrics"
  path        = "/"
  description = "access from ec2 instances to send metrics to Monitoring Account"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "sts:AssumeRole"
        ],
        Resource : [
          "arn:aws:iam::${var.monitoring_account_number}:role/aws-cloudwatch-RoleToReceiveMetrics"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-attach-cloudwatch-metrics" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.ssm.name
  policy_arn = aws_iam_policy.policy-cloudwatch-metrics.arn
}

## CodeDeploy policy------------------------------------------------------------
resource "aws_iam_policy" "policy-codeploy-apps" {
  provider    = aws.prodbackoffice
  name        = "codeploy-access-ec2-all-apps"
  path        = "/"
  description = "access from ec2 instances to apps s3 buckets. read and write"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codedeploy-commands-secure:GetDeploymentSpecification",
          "codedeploy-commands-secure:PollHostCommand",
          "codedeploy-commands-secure:PutHostCommandAcknowledgement",
          "codedeploy-commands-secure:PutHostCommandComplete"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codeploy-policy" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.ssm.name
  policy_arn = aws_iam_policy.policy-codeploy-apps.arn
}


## custom policy for s3 with encripted and access Kms---------------------------
resource "aws_iam_policy" "policy-s3-apps" {
  provider    = aws.prodbackoffice
  name        = "s3-access-ec2-all-apps"
  path        = "/"
  description = "access from ec2 instances to apps s3 buckets. read and write"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:List*",
          "s3:Get*",
          "s3-object-lambda:Get*",
          "s3-object-lambda:List*"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::*"
      },
      {

        Effect = "Allow",
        Action = [
          "kms:GenerateDataKey",
          "kms:Describe*",
          "kms:Get*",
          "kms:List*",
          "kms:Decrypt",
          "kms:Encrypt",
        ]
        Resource = [
          "${aws_kms_key.kms-s3.arn}"
        ]
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3-policy" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.ssm.name
  policy_arn = aws_iam_policy.policy-s3-apps.arn
}
