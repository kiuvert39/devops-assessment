variable "name" {
  description = "Load balancer resource name prefix"
  type        = string
}

variable "region" {
  description = "Cloud Run region"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}