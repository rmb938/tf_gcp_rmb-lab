resource "google_storage_bucket" "iceberg" {
  name          = "rmb-lab-iceberg"
  force_destroy = true

  uniform_bucket_level_access = true

  location = "US-CENTRAL1"
  versioning {
    enabled = false
  }
}

resource "google_bigquery_connection" "iceberg" {
  connection_id = "iceberg-us-central1"
  location      = "us-central1"
  cloud_resource {}
}

data "google_project" "default" {}

resource "google_project_iam_member" "iceberg" {
  project = data.google_project.default.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_bigquery_connection.default.cloud_resource[0].service_account_id}"
}

resource "google_bigquery_dataset" "iceberg" {
  dataset_id = "iceberg-us-central1"
  location   = "us-central1"
}

resource "google_bigquery_table" "osrs_prices_5m" {
  dataset_id = google_bigquery_dataset.iceberg.dataset_id
  table_id   = "osrs_prices_5m"

  biglake_configuration {
    connection_id = google_bigquery_connection.iceberg_connection.id
    file_format   = "PARQUET"
    storage_uri   = "gs://${google_storage_bucket.iceberg.name}/iceberg-data/"
    table_format  = "ICEBERG"
  }

  schema = <<EOF
[
  {
    "name": "id",
    "type": "INTEGER",
    "mode": "REQUIRED"
  },
  {
    "name": "name",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "icon",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "avgLowPrice",
    "type": "INTEGER",
    "mode": "REQUIRED"
  },
  {
    "name": "lowPriceVolume",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "lowPriceVolume",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "avgHighPrice",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "highPriceVolume",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
]
EOF

}
