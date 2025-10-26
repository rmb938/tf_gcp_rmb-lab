resource "google_storage_bucket" "vancouver_kafka_meetup_2025_nov_19" {
  name          = "rmb-lab-vancouver_kafka_meetup_2025_nov_19"
  force_destroy = true

  uniform_bucket_level_access = true

  location = "US-CENTRAL1"
  versioning {
    enabled = false
  }

  soft_delete_policy {
    retention_duration_seconds = 0
  }

  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_service_account" "vancouver_kafka_meetup_2025_nov_19" {
  account_id = "van-kafka-meetup-2025-nov-19"
}

resource "google_storage_bucket_iam_member" "vancouver_kafka_meetup_2025_nov_19" {
  bucket = google_storage_bucket.vancouver_kafka_meetup_2025_nov_19.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.vancouver_kafka_meetup_2025_nov_19.email}"
}
