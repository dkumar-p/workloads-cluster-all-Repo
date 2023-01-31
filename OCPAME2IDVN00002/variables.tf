variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}

variable "tags_SNS" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}

variable "compute-tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}

variable "account_number" {
  type = string
}

variable "main_profile" {
  #type = string
}

variable "monitoring_profile" {
  description = "SSO profile for this account"
  type        = string
}

##############################################################################################

## VPC COMMUN-------------------------------------------------------------------
variable "iberia_tgw_id" {
  type    = string
  default = "tgw-0db3fdc0f9da71974"
}


variable "vpc_azs" {
  description = "list to az´s"
  type        = list(any)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  type    = number
  default = 14
}

variable "flow_log_max_aggregation_interval" {
  type    = number
  default = 60
}

variable "flow_log_file_format" {
  type    = string
  default = "parquet"
}

variable "flow_log_log_format" {
  type    = string
  default = "$${version} $${account-id} $${vpc-id} $${subnet-id} $${instance-id} $${interface-id} $${srcaddr} $${srcport} $${dstaddr} $${dstport} $${protocol} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-src-aws-service} $${pkt-dstaddr} $${pkt-dst-aws-service} $${action} $${log-status}"
}

## VPC DSCOMMON-------------------------------------------------------------------------

variable "vpc_name_dscommon" {
  type = string
}

variable "vpc_cidr_dscommon" {
  type = string
}

variable "vpc_secondary_cidr_dscommon" {
  description = "list secundary cidr"
  type        = list(any)
  default     = []
}

variable "vpc_private_subnets_dscommon" {
  description = "list private subnets cidr"
  type        = list(any)
  default     = []
}

variable "vpc_database_subnets_dscommon" {
  description = "list private subnets cidr"
  type        = list(any)
  default     = []
}


