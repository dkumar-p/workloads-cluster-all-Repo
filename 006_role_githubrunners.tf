resource "aws_iam_role" "role_github_runners_prod" {
  name     = "RoleGithubRunners_Prod"
  provider = aws.prodbackoffice

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "efghTrustPolicy",
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

resource "aws_iam_role_policy_attachment" "AWSCodeDeployFullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
  provider   = aws.prodbackoffice
  role       = aws_iam_role.role_github_runners_prod.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}