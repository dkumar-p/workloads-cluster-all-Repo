module "create_alarms_alb_rds" {

  providers = {
    aws = aws.prodbackoffice
  }

  source = "git@github.com:Iberia-Ent/software-engineering--monitoring--infra.git//modules/create_alarms_alb_rds_workflow"
  #  source             = "git@github.com:Iberia-Ent/software-engineering--monitoring--infra.git//modules/create_alarms_alb_rds"
  #  main_profile       = var.main_profile
  account_number = var.account_number
  #  monitoring_profile = var.monitoring_profile
  tags          = var.tags
  sns_topic_arn = aws_sns_topic.topic.arn
}
