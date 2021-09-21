resource "google_project_service" "compute_engine" {
  project = "homework-tf"
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_compute_network" "vpc_network" {
  name                    = "ansible-network"
  auto_create_subnetworks = true
}


resource "google_compute_instance" "lb_vm" {
  name         = "load-balancer-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "master"]

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.id
    access_config {
      #
    }
  }

  metadata_startup_script = "apt update && apt install nginx -y"

  provisioner "local-exec" {
    command = "echo  'hello world'"
  }

}

resource "google_compute_instance" "vm1" {
  name         = "vm1-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "node"]

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.id
    # access_config {
    # }
  }
}

resource "google_compute_instance" "vm2" {
  name         = "vm2-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "node"]

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.id
    # access_config {
    # }
  }
}

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

resource "google_compute_firewall" "allow_ansible_ssh" {
  name    = "ansible-firewall-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_tags = ["master"]
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
