# Terraform State
resource "google_service_account" "tf_kubernetes_kube0" {
  account_id   = "tf-kubernetes-kube0"
  display_name = "Service Account for Kubernetes Kube0 Terraform State"
}


resource "google_storage_bucket" "tf_kubernetes_kube0" {
  name          = "rmb-lab-tf_kubernetes_kube0"
  force_destroy = true

  location = "US-CENTRAL1"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "tf_kubernetes_kube0" {
  bucket = google_storage_bucket.tf_kubernetes_kube0.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${google_service_account.tf_kubernetes_kube0.email}"
}

# Kubernetes Backup
resource "google_service_account" "kube0-backup" {
  account_id   = "kube0-backup"
  display_name = "Service Account for Kube0 Backups"
}


resource "google_storage_bucket" "kube0-backup" {
  name          = "kube0.backups.buckets.rmb938.me"
  force_destroy = true

  location = "US-CENTRAL1"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "kube0-backup" {
  bucket = google_storage_bucket.kube0-backup.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${google_service_account.kube0-backup.email}"
}
