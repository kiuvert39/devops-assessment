output "storage_bucket_name" {
  description = "Name of the application storage bucket"
  value       = module.storage.bucket_name
}

output "cloud_sql_instance_name" {
  description = "cloud sql instance name"
  value       = module.cloud_sql.instance_name
}

output "cloud_sql_connection_name" {
  description = "sql connection name"
  value       = module.cloud_sql.instance_name
}

output "cloud_sql_database_name" {
  description = "database name"
  value       = module.cloud_sql.database_name
}

output "cloud_run_service_name" {
  description = "Deployed Cloud Run service name"
  value       = module.cloud_run.service_name
}

output "cloud_run_service_url" {
  description = "Cloud Run service URL"
  value       = module.cloud_run.service_uri
}

output "load_balancer_ip" {
  description = "Public IP address of the application"
  value       = module.load_balancer.load_balancer_ip
}

output "application_url" {
  description = "Public application URL"
  value       = module.load_balancer.load_balancer_url
}


output "artifact_registry_repository_url" {
  description = "Artifact Registry URL for application Docker images"
  value       = module.artifact_registry.repository_url
}