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