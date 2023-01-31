resource "aws_iam_role" "role_github_runners_prod_backoffice" {
  provider = aws.prodbackoffice
  name     = "RoleGithubRunners_Infrastructure_Prod_backoffice"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "TrustPolicy",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::329066851743:role/RoleGithubRunners"
        },
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "LambdaFullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}
resource "aws_iam_role_policy_attachment" "IAMFullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}
resource "aws_iam_role_policy_attachment" "CloudWatchFullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonSNSFullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonDynamoDBFullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonVPCFullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonSSMFullAccess1" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonRDSFullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
resource "aws_iam_role_policy_attachment" "AmazonBackupFullAccess1" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupFullAccess"
}

resource "aws_iam_role_policy_attachment" "workflow" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod_backoffice.name
  policy_arn = aws_iam_policy.custom_role_workflow1.arn
}

resource "aws_iam_policy" "custom_role_workflow1" {
  provider    = aws.prodbackoffice
  name        = "CustomRoleWorkflow"
  path        = "/"
  description = "custom_role_workflow"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "ec2:*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "elasticloadbalancing:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "cloudwatch:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "autoscaling:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : [
              "autoscaling.amazonaws.com",
              "ec2scheduled.amazonaws.com",
              "elasticloadbalancing.amazonaws.com",
              "spot.amazonaws.com",
              "spotfleet.amazonaws.com",
              "transitgateway.amazonaws.com"
            ]
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : "elasticloadbalancing.amazonaws.com"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : "autoscaling.amazonaws.com"
          }
        }
      },
      {
        "Action" : "codedeploy:*",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "CodeStarNotificationsReadWriteAccess",
        "Effect" : "Allow",
        "Action" : [
          "codestar-notifications:CreateNotificationRule",
          "codestar-notifications:DescribeNotificationRule",
          "codestar-notifications:UpdateNotificationRule",
          "codestar-notifications:DeleteNotificationRule",
          "codestar-notifications:Subscribe",
          "codestar-notifications:Unsubscribe"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringLike" : {
            "codestar-notifications:NotificationsForResource" : "arn:aws:codedeploy:*"
          }
        }
      },
      {
        "Sid" : "CodeStarNotificationsListAccess",
        "Effect" : "Allow",
        "Action" : [
          "codestar-notifications:ListNotificationRules",
          "codestar-notifications:ListTargets",
          "codestar-notifications:ListTagsforResource",
          "codestar-notifications:ListEventTypes"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "CodeStarNotificationsSNSTopicCreateAccess",
        "Effect" : "Allow",
        "Action" : [
          "sns:CreateTopic",
          "sns:SetTopicAttributes"
        ],
        "Resource" : "arn:aws:sns:*:*:codestar-notifications*"
      },
      {
        "Sid" : "CodeStarNotificationsChatbotAccess",
        "Effect" : "Allow",
        "Action" : [
          "chatbot:DescribeSlackChannelConfigurations"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "SNSTopicListAccess",
        "Effect" : "Allow",
        "Action" : [
          "sns:ListTopics"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53resolver:*",
          "s3:*",
          "s3-object-lambda:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:CreateAlias",
          "kms:CreateKey",
          "kms:DeleteAlias",
          "kms:Describe*",
          "kms:GenerateRandom",
          "kms:Get*",
          "kms:List*",
          "kms:TagResource",
          "kms:UntagResource"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:*",
          "route53domains:*",
          "cloudfront:ListDistributions",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticbeanstalk:DescribeEnvironments",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketWebsite",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeRegions",
          "sns:ListTopics",
          "sns:ListSubscriptionsByTopic",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricStatistics"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "apigateway:GET",
        "Resource" : "arn:aws:apigateway:*::/domainnames"
      },
      {
        "Effect" : "Allow",
        "Action" : "events:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "arn:aws:iam::*:role/AWS_Events_Invoke_Targets"
      },
      {
        "Action" : [
          "elasticfilesystem:CreateFileSystem",
          "elasticfilesystem:CreateMountTarget",
          "elasticfilesystem:CreateTags",
          "elasticfilesystem:CreateAccessPoint",
          "elasticfilesystem:CreateReplicationConfiguration",
          "elasticfilesystem:DeleteFileSystem",
          "elasticfilesystem:DeleteMountTarget",
          "elasticfilesystem:DeleteTags",
          "elasticfilesystem:DeleteAccessPoint",
          "elasticfilesystem:DeleteFileSystemPolicy",
          "elasticfilesystem:DeleteReplicationConfiguration",
          "elasticfilesystem:DescribeAccountPreferences",
          "elasticfilesystem:DescribeBackupPolicy",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeFileSystemPolicy",
          "elasticfilesystem:DescribeLifecycleConfiguration",
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:DescribeMountTargetSecurityGroups",
          "elasticfilesystem:DescribeTags",
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeReplicationConfigurations",
          "elasticfilesystem:ModifyMountTargetSecurityGroups",
          "elasticfilesystem:PutAccountPreferences",
          "elasticfilesystem:PutBackupPolicy",
          "elasticfilesystem:PutLifecycleConfiguration",
          "elasticfilesystem:PutFileSystemPolicy",
          "elasticfilesystem:UpdateFileSystem",
          "elasticfilesystem:TagResource",
          "elasticfilesystem:UntagResource",
          "elasticfilesystem:ListTagsForResource",
          "elasticfilesystem:Backup",
          "elasticfilesystem:Restore",
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : "iam:CreateServiceLinkedRole",
        "Effect" : "Allow",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : [
              "elasticfilesystem.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
}
