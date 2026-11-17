variable "state_bucket_name" {
  description = "Globally unique name for the Terraform state bucket"
  type        = string
}

variable "region" {
  description = "Google Cloud region for the Terraform state bucket"
  type        = string
  default     = "europe-west1"
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}