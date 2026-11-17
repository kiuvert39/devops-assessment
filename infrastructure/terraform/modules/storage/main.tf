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