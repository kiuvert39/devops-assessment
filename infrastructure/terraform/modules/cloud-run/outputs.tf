output "service_name" {
  description = "cloud run service name"
  value       = google_cloud_run_v2_service.application.name
}

output "service_uri" {
  description = "cloude run service url"
  value       = google_cloud_run_v2_service.application.uri
}