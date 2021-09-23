
resource "google_compute_instance" "lb_vm" {
  name         = "load-balancer-instance"
  machine_type = "e2-medium"

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
  metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }

provisioner "remote-exec" {
    inline = ["sudo apt -y install python"]

    connection {
        host = "${self.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "${var.ansible_user}"
    private_key = "${file(var.ssh_key_private)}"
    }
}

provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.ssh_key_private} loadbalancer.yml" 
}
  
depends_on = [google_compute_instance.vm1, google_compute_instance.vm2]

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
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.id
    access_config {
    }
  }

    metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }

provisioner "remote-exec" {
    inline = ["sudo apt -y install python"]

    connection {
        host = "${self.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "${var.ansible_user}"
    private_key = "${file(var.ssh_key_private)}"
    }
}

provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.ssh_key_private} node.yml" 
}
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
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.id
    access_config {
    }
  }

    metadata = {
    ssh-keys = "${var.ansible_user}:${file(var.ssh_key_public)}"
  }

provisioner "remote-exec" {
    inline = ["sudo apt -y install python"]

    connection {
        host = "${self.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = var.ansible_user
    private_key = "${file(var.ssh_key_private)}"
    }
}

provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} -i '${self.network_interface.0.access_config.0.nat_ip},' --private-key ${var.ssh_key_private} node.yml" 
}
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