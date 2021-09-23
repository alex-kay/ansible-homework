resource "google_compute_firewall" "allow_traffic_ansible" {
  name    = "ansible-firewall-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["ansible"]
  target_tags = ["ansible"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "ansible-firewall-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/16"]
  target_tags = ["node"]
}

resource "google_compute_firewall" "allow_load_balancer_ingress" {
  name    = "ansible-ingress-lb"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["master"]
}