output "all_vpc_ids" {
  description = "List of all vpc´s in this account"
  value       = [module.vpc-Cluster.vpc_id]
}

## VPC--------------------------------------------------------------------------

output "vpc_id" {
  description = "vpc id of vpc"
  value       = module.vpc-Cluster.vpc_id
}

output "private_subnets" {
  description = "List private subnets of vpc"
  value       = module.vpc-Cluster.private_subnets
}

output "private_route_tables" {
  description = "List private route tables of private subnets"
  value       = module.vpc-Cluster.private_route_table_ids
}


## EC2 -------------------------------------------------------------------------
/*
output "ec2_id_1a" {
  description = "ID EC2 of instance in az eu-west-1a"
  value       = module.ec2_instance_1.id
}

*/

## ALB-NLB----------------------------------------------------------------------

output "alb_id" {
  description = "ID ALB"
  value       = module.lb-alb.lb_id
}

output "nlb_id" {
  description = "ID NLB"
  value       = module.lb-nlb.lb_id
}

output "alb_arn" {
  description = "ID ALB"
  value       = module.lb-alb.lb_arn
}

output "nlb_arn" {
  description = "ID NLB"
  value       = module.lb-nlb.lb_arn
}

output "alb_zone_id" {
  description = "ID ALB"
  value       = module.lb-alb.lb_zone_id
}

output "nlb_zone_id" {
  description = "ID NLB"
  value       = module.lb-nlb.lb_zone_id
}

