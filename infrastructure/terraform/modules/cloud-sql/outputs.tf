output "instance_name" {
  description = "Cloude sql name"
  value       = google_sql_database_instance.mysql.name
}

output "connection_name" {
  description = "cloud sql instance connection"
  value       = google_sql_database_instance.mysql.connection_name
}

output "database_name" {
  description = "Application database name"
  value       = google_sql_database.application.name
}