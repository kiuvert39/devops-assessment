
/*
 * Main Infrastructure Configuration
 *
 * This file orchestrates the deployment of the application infrastructure
 * on Google Cloud using reusable Terraform modules.
 *
 * It provisions:
 * - Cloud Storage for application file uploads.
 * - Cloud SQL (MySQL) for application data.
 * - Cloud Run to host the Nginx and PHP-FPM containers.
 * - An external HTTP Load Balancer to route incoming traffic to Cloud Run.
 * - Artifact Registry to store application container images.
 *
 * The root configuration also connects these modules with the required
 * service accounts, IAM permissions, and application configuration.
 */
 
module "storage" {
  source = "./modules/storage"

  bucket_name = var.bucket_name
  location    = var.region
  environment = var.environment
}

module "cloud_sql" {
  source = "./modules/cloud-sql"

  instance_name    = var.db_instance_name
  database_name    = var.database_name
  region           = var.region
  database_version = "MYSQL_8_0"
  db_username      = var.db_username
  db_password      = var.db_password

  tier = var.db_tier
}

module "cloud_run" {
  source = "./modules/cloud-run"

  service_name          = var.cloud_run_service_name
  region                = var.region
  nginx_image           = var.nginx_image
  php_image             = var.php_image
  environment           = var.environment
  service_account_email = google_service_account.cloud_run.email

  cloud_sql_connection_name = module.cloud_sql.connection_name
  db_username               = var.db_username
  database_name             = var.database_name
  bucket_name               = module.storage.bucket_name

  db_password_secret_id = google_secret_manager_secret.db_password.secret_id

}

module "load_balancer" {
  source = "./modules/load-balancer"

  name                   = var.load_balancer_name
  region                 = var.region
  cloud_run_service_name = module.cloud_run.service_name
  environment            = var.environment
}

module "artifact_registry" {
  source = "./modules/artifact-registry"

  project_id    = var.project_id
  location      = var.region
  repository_id = "assessment-images"
  environment   = var.environment
}