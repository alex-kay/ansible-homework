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
        command = "rm hosts"
  }
}
resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "echo 'vm1 ${google_compute_instance.vm1.network_interface.0.access_config.0.nat_ip}' >> hosts"
    
  }
  depends_on = [null_resource.example0, google_compute_instance.vm1]
}
resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = "echo 'vm1 ${google_compute_instance.vm2.network_interface.0.access_config.0.nat_ip}' >> hosts"
    
  }
  depends_on = [null_resource.example0, google_compute_instance.vm2]
}