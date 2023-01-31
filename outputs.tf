output "all_vpc_ids" {
  description = "List of all vpc´s in this account"
  value       = [module.vpc-route53-wspbackoffice.vpc_id]
}

## VPC--------------------------------------------------------------------------

output "vpc_id" {
  description = "vpc id of vpc"
  value       = module.vpc-route53-wspbackoffice.vpc_id
}

output "private_subnets" {
  description = "List private subnets of vpc"
  value       = module.vpc-route53-wspbackoffice.private_subnets
}

output "private_route_tables" {
  description = "List private route tables of private subnets"
  value       = module.vpc-route53-wspbackoffice.private_route_table_ids
}

# ROUTE 53----------------------------------------------------------------------
output "gccaddress_route53_zone_ids" {
  value = module.phz-gccaddress-workloads-prod-backoffice.route53_zone_zone_id
}

output "gccaddress_route53_zone_name" {
  value = module.phz-gccaddress-workloads-prod-backoffice.route53_zone_name
}

output "route53_zone_name" {
  description = "Name PHZ Route 53"
  value       = module.phz-workloads-prod-backoffice.route53_zone_name
}

output "route53_zone_zone_id" {
  description = "ID PHZ Route 53"
  value       = module.phz-workloads-prod-backoffice.route53_zone_zone_id
}

## KMS -------------------------------------------------------------------------

output "kms_s3_id" {
  description = "ID KMS for S3"
  value       = aws_kms_key.kms-s3.key_id
}

output "kms_s3_arn" {
  description = "ARN KMS for S3"
  value       = aws_kms_key.kms-s3.arn
}

output "kms_ebs_id" {
  description = "ID KMS for EBS"
  value       = aws_kms_key.kms-ebs.key_id
}
output "kms_ebs_arn" {
  description = "ARN KMS for EBS"
  value       = aws_kms_key.kms-ebs.arn
}

output "kms_backup_id" {
  description = "ID KMS for Backup"
  value       = aws_kms_key.kms-backup.key_id
}

output "kms_backup_arn" {
  description = "ARN KMS for Backup"
  value       = aws_kms_key.kms-backup.arn
}

## BACKUP VAULT-----------------------------------------------------------------
output "vault_id" {
  description = "ID Vault Backup"
  value       = aws_backup_vault.vault-backup[0].id
}

output "vault_name" {
  description = "Name Vault Backup"
  value       = aws_backup_vault.vault-backup[0].name
}

### ARN IAM ROLE TO UPDATE IN MONITORING ACCOUNT -------------------------------

output "iam_role_lambda_to_monitoring_account" {
  value = module.create_lambda_event_bridge_cloudwatch_alarms.output_iam-role_for_lambda-CreateAlarmsDashboardsCloudwatch_in_Monitoring_arn
}
