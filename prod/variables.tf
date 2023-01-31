variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}

variable "account_number" {
  description = "Account number"
  type        = string
}

variable "main_profile" {
  description = "SSO profile for this account"
  type        = string
}
/*
variable "globalsharedservices_profile" {
  description = "SSO profile for this account"
  type        = string
}
*/
variable "networking_profile" {
  description = "SSO profile for this account"
  type        = string
}


variable "monitoring_profile" {
  description = "SSO profile for this account"
  type        = string
}


## VPC COMMUN-------------------------------------------------------------------
variable "iberia_tgw_id" {
  description = "TGW Iberia"
  type        = string
  default     = "tgw-0db3fdc0f9da71974"
}

variable "gcc_tgw_id" {
  description = "TGW GCC"
  type        = string
  default     = "tgw-0858e4d5e466d734d"
}

variable "vpc_azs" {
  description = "List AZS for Subnets"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Flow vpc Retention Days"
  type        = number
  default     = 14
}

variable "flow_log_max_aggregation_interval" {
  description = "Flow vpc aggregation_interval"
  type        = number
  default     = 60
}

variable "flow_log_file_format" {
  description = "Flow vpc file format"
  type        = string
  default     = "parquet"
}

variable "flow_log_log_format" {
  description = "Flow vpc log format"
  type        = string
  default     = "$${version} $${account-id} $${vpc-id} $${subnet-id} $${instance-id} $${interface-id} $${srcaddr} $${srcport} $${dstaddr} $${dstport} $${protocol} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-src-aws-service} $${pkt-dstaddr} $${pkt-dst-aws-service} $${action} $${log-status}"
}

## VPC ACCOUNT------------------------------------------------------------------
variable "name_vpc_cluster" {
  description = "Vpc name for account"
  type        = string
  default     = ""
}

variable "vpc_cidr_cluster" {
  description = "Vpc CIDR for Account"
  type        = string
  default     = ""
}

variable "vpc_secundary_cidr_cluster" {
  description = "Vpc sencundary CIDR for Account"
  type        = list(string)
  default     = []
}

variable "vpc_private_subnets_cluster" {
  description = "List private subnets for Account"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets_cluster" {
  description = "List public subnets for Account"
  type        = list(string)
  default     = []
}

## EC2 -------------------------------------------------------------------------

variable "ami_master" {
  description = "Id AMI of the master instance jboss"
  type        = string
  #default     = "ami-03ee68e5017554ba8"
}


