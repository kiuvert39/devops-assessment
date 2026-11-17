output "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  value       = google_storage_bucket.assesment_bucket.name

}

output "bucket_url" {
  description = "Google Cloud Storage bucket URL"
  value       = google_storage_bucket.assesment_bucket.url

}