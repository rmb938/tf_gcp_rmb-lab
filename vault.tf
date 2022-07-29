data "google_compute_image" "fedora-35" {
  family  = "fedora-35"
  project = "fedora-cloud"
}

resource "google_service_account" "vault" {
  account_id   = "hashicorp-vault"
}

resource "google_compute_instance" "vault" {
  name = "vault"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  
  allow_stopping_for_update = true
  
  hostname = "vault.rmb938.github.beta.tailscale.net"
  
  tags = ["public-ssh-access", "tailscale"]
  
  network_interface {
    subnetwork = google_compute_network.default-dualstack.id
    stack_type = "IPV4_IPV6"
  }
  
  boot_disk {
    initialize_params {
      size  = "10"
      type  = "pd-standard"
      image = "debian-cloud/debian-9"
    }
  }
  
  service_account {
    email  = google_service_account.vault.email
    scopes = ["cloud-platform"]
  }
}
