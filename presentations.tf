resource "google_storage_bucket" "twin_cities_kafka_meetup_2025_oct_02" {
  name          = "rmb-lab-twin_cities_kafka_meetup_2025_oct_02"
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

resource "google_service_account" "twin_cities_kafka_meetup_2025_oct_02" {
  account_id = "twc-kafka-meetup-2025-oct-02"
}

resource "google_storage_bucket_iam_member" "twin_cities_kafka_meetup_2025_oct_02" {
  bucket = google_storage_bucket.twin_cities_kafka_meetup_2025_oct_02.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.twin_cities_kafka_meetup_2025_oct_02.email}"
}
