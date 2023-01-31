locals {

  existsTagGroupComponentGrouping = try(var.tags_SNS["group:component-grouping"], "doesnt-exists")
  tagForName                      = local.existsTagGroupComponentGrouping == "doesnt-exists" ? "ib:resource:application" : "group:component-grouping"
}

resource "aws_sns_topic" "topic" {
  provider     = aws.monitoring
  name         = "SNS_Topic_${var.tags_SNS[local.tagForName]}_${var.tags_SNS["ib:resource:environment"]}"
  display_name = "IBERIA-AWS-ALERTAS"
  policy       = data.aws_iam_policy_document.SNS_BES.json
  tags = merge(var.tags_SNS,
    {
      "ib:resource:name" = "SNS_Topic_${var.tags_SNS[local.tagForName]}_${var.tags_SNS["ib:resource:environment"]}"
    }
  )
}
data "aws_iam_policy_document" "SNS_BES" {
  policy_id = "__default_policy_ID"
  statement {
    sid = "__default_statement_ID"
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
    ]
    effect    = "Allow"
    resources = ["arn:aws:sns:eu-west-1:207656073076:SNS_Topic_con006_prod"]
    principals {
      type = "AWS"
      identifiers = ["706552515435",
      "207656073076"]
    }
  }
}
resource "aws_sns_topic_subscription" "email-target" {
  provider  = aws.monitoring
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = "cloud.infra.support.op@iberia.es"
}

#resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
#  provider  = aws.monitoring
#  topic_arn = aws_sns_topic.topic.arn
#  protocol  = "sqs"
#  endpoint  = "arn:aws:sqs:eu-west-1:706552515435:SQS_BES_UAT"
#}
