variable "project_id" {
  description = "Google Cloud project id"
  type        = string

}

variable "region" {
  description = "Google cloude region"
  type        = string
  default     = "europe-west1"

}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique Cloud Storage bucket name"

  type = string
}


variable "db_instance_name" {
  description = "cloud sql instance name"
  type        = string
}


variable "cloud_run_service_name" {
  description = "cloud run sevice name"
  type        = string
}

variable "nginx_image" {
  description = "nginx container image uri"
  type        = string
}

variable "php_image" {
  description = "PHP-FPM container image uri"
  type        = string
}

variable "load_balancer_name" {
  description = "Load balancer resource name prefix"
  type        = string
  default     = "assessment-lb"
}

variable "db_tier" {
  description = "Cloud SQL machine tier"
  type        = string
  default     = "db-f1-micro"
}
variable "database_name" {
  description = "Application database name"
  type        = string
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