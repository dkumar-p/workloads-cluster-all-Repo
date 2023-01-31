resource "aws_iam_user" "MGNuser" {

  name     = "MGNuser"
  provider = aws.prodbackoffice
}


resource "aws_iam_user_policy_attachment" "MGNuser-Policy-Attachment" {
  user = aws_iam_user.MGNuser.name

  provider = aws.prodbackoffice


  policy_arn = "arn:aws:iam::aws:policy/AWSApplicationMigrationAgentPolicy"
}