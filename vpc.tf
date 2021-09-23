resource "google_compute_network" "vpc_network" {
  name = "ansible-network"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "ansible-subnetwork"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
}

resource "google_compute_router" "router" {
  name    = "my-router"
  region  = var.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}

# resource "google_compute_router_nat" "nat" {
#   name                               = "ansible-router-nat"
#   router                             = google_compute_router.router.name
#   region                             = var.region
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

#   log_config {
#     enable = true
#     filter = "ERRORS_ONLY"
#   }
# }