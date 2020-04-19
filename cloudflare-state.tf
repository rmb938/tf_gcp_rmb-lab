# Terraform State
resource "google_service_account" "tf_cloudflare" {
  account_id   = "tf-cloudflare"
  display_name = "Service Account for Cloudflare Terraform State"
}


resource "google_storage_bucket" "tf_cloudflare" {
  name          = "rmb-lab-tf_cloudflare"
  force_destroy = true

  location = "US-CENTRAL1"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "tf_cloudflare" {
  bucket = google_storage_bucket.tf_cloudflare.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${google_service_account.tf_cloudflare.email}"
}
