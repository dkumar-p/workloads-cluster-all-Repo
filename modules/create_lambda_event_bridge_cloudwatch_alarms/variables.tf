/*
variable "main_profile" {
  description = "Profile del usuario de la cuenta en la que se encuentran los recursos a monitorizar"
  type        = string
}
*/
variable "account_number" {
  description = "Número de la cuenta en la que se encuentran los recursos a monitorizar"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}
