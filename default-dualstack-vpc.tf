resource "google_compute_network" "default-dualstack" {
  name                    = "default-dualstack"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "default-dualstack-us-central1" {
  name             = "us-central1"
  ip_cidr_range    = "10.128.0.0/20"
  region           = "us-central1"
  network          = google_compute_network.default-dualstack.id
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
}

resource "google_compute_firewall" "default-dualstack-allow-icmp-ipv4" {
  name    = "default-dualstack-allow-icmp-ipv4"
  network = google_compute_network.default-dualstack.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}

resource "google_compute_firewall" "default-dualstack-allow-icmp-ipv6" {
  name    = "default-dualstack-allow-icmp-ipv6"
  network = google_compute_network.default-dualstack.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["::/0"]
  priority = 65534
}

resource "google_compute_firewall" "default-dualstack-allow-ssh-ipv4" {
  name    = "default-dualstack-allow-ssh-ipv4"
  network = google_compute_network.default-dualstack.name

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  target_tags   = ["public-ssh-access"]
  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}


resource "google_compute_firewall" "default-dualstack-allow-ssh-ipv6" {
  name    = "default-dualstack-allow-ssh-ipv6"
  network = google_compute_network.default-dualstack.name

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  target_tags   = ["public-ssh-access"]
  source_ranges = ["::/0"]
  priority = 65534
}

resource "google_compute_firewall" "default-dualstack-allow-tailscale-ipv4" {
  name    = "default-dualstack-allow-tailscale-ipv4"
  network = google_compute_network.default-dualstack.name

  allow {
    protocol  = "udp"
    ports     = ["41641"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["tailscale"]
  priority = 65534
}

resource "google_compute_firewall" "default-dualstack-allow-tailscale-ipv6" {
  name    = "default-dualstack-allow-tailscale-ipv6"
  network = google_compute_network.default-dualstack.name

  allow {
    protocol  = "udp"
    ports     = ["41641"]
  }

  source_ranges = ["::/0"]
  target_tags = ["tailscale"]
  priority = 65534
}
