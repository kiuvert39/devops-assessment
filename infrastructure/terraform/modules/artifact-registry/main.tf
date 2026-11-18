/*
 * Artifact Registry
 *
 * Creates a Docker repository for storing the application's container images.
 *
 * The repository stores the Nginx and PHP-FPM images built locally or
 * through the GitHub Actions CI/CD pipeline.
 *
 * Cloud Run retrieves these images from Artifact Registry during deployment.
 */
resource "google_artifact_registry_repository" "docker" {
  location      = var.location
  repository_id = var.repository_id
  description   = "Docker images for the DevOps assessment application"
  format        = "DOCKER"

  labels = {
    managed_by  = "terraform"
    environment = var.environment
  }
}