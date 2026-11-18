/*
 * Cloud SQL - MySQL Database
 *
 * Provisions a managed MySQL database instance for the application.
 *
 * It creates:
 * - A Cloud SQL MySQL instance.
 * - An application database within the instance.
 * - A dedicated database user with a configured password.
 *
 * The instance includes automated backups and disk auto-resizing.
 * Cloud Run connects to the database through the Cloud SQL integration.
 *
 * Database credentials are supplied through Terraform variables and
 * the application retrieves its password from Secret Manager at runtime.
 */


resource "google_sql_database_instance" "mysql" {
  name             = var.instance_name
  region           = var.region
  database_version = var.database_version

  settings {
    tier = var.tier

    availability_type = "ZONAL"

    disk_type       = "PD_SSD"
    disk_size       = 10
    disk_autoresize = true

    backup_configuration {
      enabled = true
    }

    ip_configuration {
      ipv4_enabled = true
    }
  }
  deletion_protection = true

}

resource "google_sql_database" "application" {
  name     = var.database_name
  instance = google_sql_database_instance.mysql.name
}


resource "google_sql_user" "application" {
  name     = var.db_username
  instance = google_sql_database_instance.mysql.name
  password = var.db_password
}