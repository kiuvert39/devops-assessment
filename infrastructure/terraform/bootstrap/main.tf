/*
 * Terraform State Bucket - Bootstrap
 *
 * Creates the Google Cloud Storage bucket used to store Terraform's
 * remote state for the main infrastructure configuration.
 *
 * The bucket is configured with:
 * - Uniform bucket-level access.
 * - Public access prevention.
 * - Object versioning to support state recovery.
 *
 * This configuration must be initialized and applied separately
 * before configuring the main Terraform GCS backend.
 */

resource "google_storage_bucket" "terraform_state" {
  name     = var.state_bucket_name
  location = var.region

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  labels = {
    managed_by = "terraform"
    purpose    = "terraform-state"
  }
}