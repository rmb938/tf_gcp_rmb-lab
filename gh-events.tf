resource "google_storage_bucket" "gh_events" {
  name          = "rmb-lab-gh_events"
  force_destroy = true

  uniform_bucket_level_access = true
  storage_class               = "COLDLINE"

  location = "US-CENTRAL1"
  versioning {
    enabled = false
  }
}

resource "google_storage_bucket_iam_member" "gh_events" {
  bucket = google_storage_bucket.gh_events.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:gh-events-rbelgrave@bored-engineering.iam.gserviceaccount.com"
}
