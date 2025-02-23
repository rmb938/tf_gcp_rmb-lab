resource "google_service_account" "hashicorp-vault" {
  account_id = "hashicorp-vault"
}

resource "google_storage_bucket" "hashicorp-vault" {
  name     = "rmb-lab-hashicorp-vault"
  location = "US-CENTRAL1"
}

resource "google_storage_bucket_iam_member" "hashicorp-vault" {
  bucket = google_storage_bucket.hashicorp-vault.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.hashicorp-vault.email}"
}

resource "google_kms_key_ring" "hashicorp-vault" {
  name     = "hashicorp-vault"
  location = "global"
}

resource "google_kms_crypto_key" "hashicorp-vault" {
  name     = "hashicorp-vault"
  key_ring = google_kms_key_ring.hashicorp-vault.id

  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_member" "hashicorp-vault-encryptdecrypt" {
  crypto_key_id = google_kms_crypto_key.hashicorp-vault.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.hashicorp-vault.email}"
}

resource "google_kms_crypto_key_iam_member" "hashicorp-vault-viewer" {
  crypto_key_id = google_kms_crypto_key.hashicorp-vault.id
  role          = "roles/cloudkms.viewer"
  member        = "serviceAccount:${google_service_account.hashicorp-vault.email}"
}

# data "google_compute_image" "ubuntu-noble" {
#   family  = "ubuntu-2404-lts-amd64"
#   project = "ubuntu-os-cloud"
# }

# resource "google_compute_instance" "hashicorp-vault" {
#   name         = "hashicorp-vault"
#   machine_type = "e2-micro"
#   zone         = "us-central1-a"

#   allow_stopping_for_update = true

#   hostname = "hashi-vault.tailnet-047c.ts.net"

#   tags = ["tailscale"]

#   network_interface {
#     subnetwork = google_compute_subnetwork.default-dualstack-us-central1.name
#     stack_type = "IPV4_IPV6"

#     access_config {
#       network_tier = "STANDARD"
#     }

#     ipv6_access_config {
#       network_tier = "PREMIUM"
#     }
#   }

#   boot_disk {
#     initialize_params {
#       size  = "30"
#       type  = "pd-standard"
#       image = data.google_compute_image.ubuntu-noble.id
#     }
#   }

#   shielded_instance_config {
#     enable_secure_boot          = true
#     enable_vtpm                 = true
#     enable_integrity_monitoring = true
#   }

#   scheduling {
#     on_host_maintenance = "MIGRATE"
#     automatic_restart   = true
#   }

#   service_account {
#     email  = google_service_account.hashicorp-vault.email
#     scopes = ["cloud-platform", "storage-rw", "https://www.googleapis.com/auth/cloudkms"]
#   }
# }
