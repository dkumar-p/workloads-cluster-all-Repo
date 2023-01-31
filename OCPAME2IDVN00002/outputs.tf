output "vpc_name" {
  value = module.vpc-workloads-commercial-common.vpc_id
}

output "private_subnets" {
  description = "List private subnets of vpc"
  value       = module.vpc-workloads-commercial-common.private_subnets
}

output "private_route_tables" {
  description = "List private route tables of private subnets"
  value       = module.vpc-workloads-commercial-common.private_route_table_ids
}
output "database_subnets" {
  description = "List private subnets of vpc"
  value       = module.vpc-workloads-commercial-common.database_subnets
}