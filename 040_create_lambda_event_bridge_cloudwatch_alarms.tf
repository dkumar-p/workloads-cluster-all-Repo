module "create_lambda_event_bridge_cloudwatch_alarms" {
  source = "git@github.com:Iberia-Ent/software-engineering--workloads-prod-backoffice--infra.git//modules/create_lambda_event_bridge_cloudwatch_alarms"
  providers = {
    aws = aws.prodbackoffice
  }
  #main_profile   = var.main_profile
  account_number = var.account_number
  tags           = var.tags
}
