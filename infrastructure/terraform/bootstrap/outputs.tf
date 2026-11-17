output "state_bucket_name" {
  description = "Name of the Terraform remote state bucket"
  value       = google_storage_bucket.terraform_state.name
}

output "state_bucket_url" {
  description = "Google Cloud Storage URL of the state bucket"
  value       = google_storage_bucket.terraform_state.url
}