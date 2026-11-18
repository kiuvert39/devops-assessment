/*
 * Identity and Access Management (IAM)
 *
 * This configuration defines the permissions required by the application
 * to interact securely with Google Cloud services.
 *
 * It:
 * - Creates a dedicated service account for Cloud Run.
 * - Grants access to Cloud SQL and Cloud Storage.
 * - Allows the application to retrieve the database password from Secret Manager.
 * - Configures public invocation of the Cloud Run service through IAM.
 *
 * Using a dedicated service account avoids relying on broad default
 * project permissions for the application.
 */

resource "google_service_account" "cloud_run" {
  account_id   = "cloud-run-${var.environment}"
  display_name = "Cloud Run Service Account"
  description  = "Identity used by the Cloud Run application"
}


resource "google_project_iam_member" "cloud_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = var.region
  name     = module.cloud_run.service_name

  role   = "roles/run.invoker"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "storage_object_user" {
  bucket = module.storage.bucket_name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password-${var.environment}"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}

resource "google_secret_manager_secret_iam_member" "db_password_access" {
  secret_id = google_secret_manager_secret.db_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}