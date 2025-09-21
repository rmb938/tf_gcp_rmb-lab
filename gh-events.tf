resource "google_storage_bucket" "gh_events" {
  name          = "rmb-lab-gh_events"
  force_destroy = true

  uniform_bucket_level_access = true
  storage_class               = "COLDLINE"

  location = "US-CENTRAL1"
  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      storage_class = "COLDLINE"
      type          = "SetStorageClass"
    }
    condition {
      age                                     = 7
      days_since_custom_time                  = 0
      days_since_noncurrent_time              = 0
      matches_prefix                          = []
      matches_storage_class                   = []
      matches_suffix                          = []
      num_newer_versions                      = 0
      send_days_since_custom_time_if_zero     = false
      send_days_since_noncurrent_time_if_zero = false
      send_num_newer_versions_if_zero         = false
      with_state                              = "ANY"
    }
  }
}

resource "google_storage_bucket_iam_member" "gh_events" {
  bucket = google_storage_bucket.gh_events.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:gh-events-rbelgrave@bored-engineering.iam.gserviceaccount.com"
}
