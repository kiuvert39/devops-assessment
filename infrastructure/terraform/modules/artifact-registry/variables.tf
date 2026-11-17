variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "location" {
  description = "Artifact Registry repository region"
  type        = string
}

variable "repository_id" {
  description = "Artifact Registry repository name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}