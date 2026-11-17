variable "service_name" {
  description = "Cloud run service name"
  type        = string
}

variable "region" {
  description = "cloud run deployemnt region"
  type        = string
}

variable "nginx_image" {
  description = "Nginx container image URI"
  type        = string
}

variable "php_image" {
  description = "PHP-FPM container image URI"
  type        = string
}

variable "environment" {
  description = "deployment environment"
  type        = string
}

variable "service_account_email" {
  description = "Service account used by Cloud Run"
  type        = string
}


variable "cloud_sql_connection_name" {
  description = "Cloud SQL instance connection name"
  type        = string
}

variable "db_username" {
  description = "Application database user name"
  type        = string
}

variable "database_name" {
  description = "Application database name"
  type        = string
}

variable "bucket_name" {
  description = "Cloud Storage bucket name"
  type        = string
}

variable "db_password_secret_id" {
  description = "Secret Manager secret ID for the database password"
  type        = string
}