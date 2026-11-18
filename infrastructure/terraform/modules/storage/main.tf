/*
 * Cloud Storage Bucket
 *
 * Provisions a Google Cloud Storage bucket for application file uploads.
 *
 * The bucket is configured with:
 * - Standard storage class.
 * - Uniform bucket-level access for centralized IAM management.
 * - Public access prevention to protect stored files.
 * - Object versioning to support recovery of previous object versions.
 *
 * The Cloud Run service account receives the permissions required
 * to interact with the bucket.
 */
resource "google_storage_bucket" "assesment_bucket" {
  name                        = var.bucket_name
  location                    = var.location
  storage_class               = "STANDARD"
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }


  labels = {
    managed_by  = "terraform"
    environment = var.environment
  }

}