variable "bucket_name" {
  description = "Globally unique Cloud Storage bucket name"
  type        = string
}

variable "location" {
  description = "Cloud Storage bucket location"
  type        = string

}

variable "environment" {
  description = "Deployment environment"
  type        = string
}