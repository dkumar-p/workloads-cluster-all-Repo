variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}

variable "compute-tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}
variable "account_number" {
  description = "Account number"
  type        = string
}
/*
variable "main_profile" {
  description = "SSO profile for this account"
  type        = string
}

variable "networking_profile" {
  description = "SSO profile for this account"
  type        = string
}

variable "globalsharedservices_profile" {
  description = "SSO profile for this account"
  type        = string
}

variable "gccaddress_profile" {
  description = "SSO profile for this account"
  type        = string
}
*/

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
variable "vpc_name_account" {
  description = "Vpc name for account"
  type        = string
  default     = ""
}

variable "vpc_cidr_account" {
  description = "Vpc CIDR for Account"
  type        = string
  default     = ""
}

variable "vpc_secundary_cidr_account" {
  description = "Vpc sencundary CIDR for Account"
  type        = list(string)
  default     = []
}

variable "vpc_private_subnets_account" {
  description = "List private subnets for Account"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets_account" {
  description = "List public subnets for Account"
  type        = list(string)
  default     = []
}

## VPC route53------------------------------------------------------------------
variable "vpc_name_route53" {
  description = "Vpc name for Dummy vpc for route 53"
  type        = string
  default     = ""
}

variable "vpc_cidr_route53" {
  description = "Vpc CIDR for Dummy vpc for route 53"
  type        = string
  default     = ""
}

variable "vpc_secundary_cidr_route53" {
  description = "List Secundary CIDR for Dummy vpc for route 53"
  type        = list(string)
  default     = []
}

variable "vpc_private_subnets_route53" {
  description = "List private subnets for Dummy vpc for route 53"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets_route53" {
  description = "List public subnets for Dummy vpc for route 53"
  type        = list(string)
  default     = []
}

## VAULT BACKUP-----------------------------------------------------------------
variable "create_vault" {
  description = "Variable for create vault Backup"
  type        = bool
  default     = true
}

## MONITORING AND LOGGING-------------------------------------------------------

variable "monitoring_account_number" {
  type    = string
  default = "207656073076"
}

variable "logging_account_number" {
  type    = string
  default = "146797033453"
}


## EVENTBRIDGE -----------------------------------------------------------------
variable "JBOSS_HOME" {
  description = "Id AMI of the master instance jboss"
  type        = string
  default     = "/opt/jws-5.6/tomcat"
}

variable "JBOSS_HOME_EAP" {
  description = "Id AMI of the master instance jboss"
  type        = string
  default     = "/opt/jboss-eap-7.4"
}
