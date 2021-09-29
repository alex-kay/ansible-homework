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
  source_ranges = ["10.0.0.0/16"]
  target_tags   = ["ansible"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "ansible-firewall-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ansible"]
}

resource "google_compute_firewall" "allow_load_balancer_ingress" {
  name    = "ansible-ingress-lb"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["lb"]
}
resource "google_compute_firewall" "allow_windows_egress" {
  name    = "windows-egress-fw"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["1688"]
  }
  target_tags        = ["win"]
  destination_ranges = ["35.190.247.13/32"]
  direction          = "EGRESS"
}
resource "google_compute_firewall" "allow_windows_rdp" {
  name    = "windows-ingress-rdp"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags   = ["win"]
  source_ranges = ["0.0.0.0/0"]
}