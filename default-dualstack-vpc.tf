resource "google_compute_network" "default_dualstack" {
  name                    = "default-dualstack"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "default_dualstack_us-central1" {
  name             = "us-central1"
  ip_cidr_range    = "10.128.0.0/20"
  region           = "us-central1"
  network          = google_compute_network.default_dualstack.id
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
}

resource "google_compute_firewall" "default_dualstack_allow-icmp" {
  name    = "default-dualstack_allow-icmp"
  network = google_compute_network.default_dualstackt.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default_dualstack_allow-ssh" {
  name    = "default-dualstack_allow-ssh"
  network = google_compute_network.default_dualstackt.name

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  target_tags   = ["public-ssh-access"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default_dualstack_allow-tailscale" {
  name    = "default-dualstack_allow-tailscale"
  network = google_compute_network.default_dualstackt.name

  allow {
    protocol  = "udp"
    ports     = ["41641"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["tailscale"]
}
