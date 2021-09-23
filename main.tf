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
    command = "echo '[nodes] \n ${google_compute_instance.vm1.network_interface.0.access_config.0.nat_ip} \n ${google_compute_instance.vm2.network_interface.0.access_config.0.nat_ip} \n[lb] \n ${google_compute_instance.vm_lb.network_interface.0.access_config.0.nat_ip}' > hosts"
  }
  provisioner "local-exec" {
    command = "echo 'upstream backend {\nserver ${google_compute_instance.vm1.network_interface.0.network_ip}:80;\nserver ${google_compute_instance.vm2.network_interface.0.network_ip}:80;\n}\nserver {\n listen 80;\n listen [::]:80;\n location / {\n proxy_pass http://backend;\n proxy_set_header Host $host;\n } \n}' > lb.conf"
  }
  depends_on = [
    google_compute_instance.vm1,
    google_compute_instance.vm2,
    google_compute_instance.vm_lb,
    # google_compute_router_nat.nat
  ]
}
resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} -i hosts --private-key ${var.ssh_key_private} provision.yml"
  }
  depends_on = [
    null_resource.example0
  ]
}