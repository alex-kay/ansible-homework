resource "google_compute_network" "vpc_network" {
  name                    = "ansible-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "ansible-subnetwork"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
}


# resource "google_compute_route" "win_kms" {
#   name             = "windows-kms-route"
#   dest_range       = "35.190.247.13/32"
#   network          = google_compute_network.vpc_network.name
#   next_hop_gateway = "default-internet-gateway"
# }