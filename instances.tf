
resource "google_compute_instance" "vm_lb" {
  name         = "load-balancer-instance"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "lb"]

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {
      #
    }
  }
  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }

  metadata_startup_script = "sudo apt -y install python"

}

resource "google_compute_instance" "vm1" {
  name         = "vm1-instance"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "node"]

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {
    }
  }

  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }
  metadata_startup_script = "sudo apt -y install python"

}

resource "google_compute_instance" "vm2" {
  name         = "vm2-instance"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  tags = ["ansible", "node"]

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {
    }
  }

  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }
  metadata_startup_script = "sudo apt -y install python"

}
// resource "google_compute_instance" "vm-win" {
//   name         = "win-instance"
//   machine_type = "e2-medium"

//   boot_disk {
//     initialize_params {
//       image = "windows-cloud/windows-server-2019-dc-v20210914"
//     }
//   }
//   metadata {
//     windows-startup-script-url = var.bucket_startup_win
//   }
//   tags = ["ansible", "node"]

//   network_interface {
//     # A default network is created for all GCP projects
//     network = google_compute_network.vpc_network.id
//     # access_config {
//     # }
//   }
// }