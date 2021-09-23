resource "google_project_service" "compute_engine" {
  project = var.project
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "null_resource" "example0" {
  provisioner "local-exec" {
    command = "echo '[nodes] \n vm1 ${google_compute_instance.vm1.network_interface.0.access_config.0.nat_ip} \n vm2 ${google_compute_instance.vm2.network_interface.0.access_config.0.nat_ip}' > hosts"
  }
  depends_on = [
      google_compute_instance.vm1,
      google_compute_instance.vm2
    ]
}
resource "null_resource" "example1" {
    provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} --private-key ${var.ssh_key_private} node.yml"
    }
    depends_on = [
        null_resource.example0
    ]
}