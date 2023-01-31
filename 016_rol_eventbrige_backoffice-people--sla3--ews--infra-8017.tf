resource "aws_iam_role" "eventbrige-sla3--ews--infra-8017" {
  provider = aws.prodbackoffice
  name     = format("%s%s%s%s-%s", "ov", var.tags["ib:resource:letter-ev"], "ame2idae", "sla3-ews-infra-8017", "00001")

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
          Service = "events.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}


## custom policy for s3 with encripted and access Kms---------------------------
resource "aws_iam_policy" "policy-eventbrige-sla3--ews--infra-8017" {
  provider    = aws.prodbackoffice
  name        = "cloudwatch-eventbrige-access-sla3--ews--infra-8017"
  path        = "/"
  description = "access eventbrige and ec2"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:SendCommand"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ec2:eu-west-1:772838718480:instance/*"
        ],
        Condition = {
          StringEquals = {
            "ec2:ResourceTag/*" : [
              "backoffice-people--sla3--ews--infra-8017"
            ]
          }
        }
      },
      {
        "Action" : "ssm:SendCommand",
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:ssm:eu-west-1:*:document/AWS-RunShellScript"
        ]
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "eventbrige-sla3--ews--infra-8017" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.eventbrige-sla3--ews--infra-8017.name
  policy_arn = aws_iam_policy.policy-eventbrige-sla3--ews--infra-8017.arn
}
