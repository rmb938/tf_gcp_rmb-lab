# Packer Network
resource "google_compute_network" "packer" {
  name = "packer"

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "packer" {
  name = "packer"

  network = google_compute_network.packer.id
  region  = "us-central1"

  ip_cidr_range            = "10.2.0.0/29"
  private_ip_google_access = true

}


resource "google_compute_firewall" "packer-allow-icmp" {
  name    = "packer-allow-icmp"
  network = google_compute_network.packer.name

  allow {
    protocol = "icmp"
  }

  priority      = "65534"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "packer-allow-ssh" {
  name    = "packer-allow-ssh"
  network = google_compute_network.packer.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  priority      = "65534"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_service_account" "packer" {
  account_id   = "packer"
  display_name = "Service Account for Packer"
}

resource "google_project_iam_member" "packer-compute-admin" {
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.packer.email}"
  project = "rmb-lab"
}

resource "google_project_iam_member" "packer-service-account-user" {
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.packer.email}"
  project = "rmb-lab"
}

# Kubernetes Backup Buckets
resource "google_service_account" "kube-baremetal" {
  account_id   = "kube-baremetal"
  display_name = "Service Account for Kube BareMetal Imaging"
}

resource "google_storage_bucket" "kube-baremetal" {
  name          = "kube-baremetal.buckets.rmb938.me"
  force_destroy = true

  location = "US-CENTRAL1"
}

resource "google_storage_bucket_iam_member" "kube-baremetal" {
  bucket = google_storage_bucket.kube-baremetal.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${google_service_account.kube-baremetal.email}"
}
