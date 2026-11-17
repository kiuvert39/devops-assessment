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