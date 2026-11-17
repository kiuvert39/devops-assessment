variable "instance_name" {
  description = "Cloud SQL instance name"
  type        = string

}

variable "database_name" {
  description = "Application database name"
  type        = string
}

variable "region" {
  description = "Cloude SQL region"
  type        = string

}

variable "database_version" {
  description = "MSQL database version"
  type        = string
  default     = "MYSQL_8_0"

}

variable "tier" {

  description = "Cloude Sql machine tier"
  type        = string
  default     = "db-f1-micro"
}

variable "db_username" {
  description = "Application MySQL username"
  type        = string
}

variable "db_password" {
  description = "Application MySQL password"
  type        = string
  sensitive   = true
}

