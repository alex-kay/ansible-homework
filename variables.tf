variable "project" {
    default = "homework-tf"
}
variable "region" {
    default = "us-central1"
}
variable "zone" {
    default    = "us-central1-c"
}
variable "ssh_key_public" {
    default = "~/.ssh/id_rsa.pub"
}
variable "ssh_key_private" {
    default = "~/.ssh/id_rsa"
}