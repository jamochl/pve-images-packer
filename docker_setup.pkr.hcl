variable "PM_API_TOKEN_SECRET" {
  default = env("PM_API_TOKEN_SECRET")
}
variable "PM_API_TOKEN_ID" {
  default = env("PM_API_TOKEN_ID")
}
variable "PM_API_URL" {
  default = env("PM_API_URL")
}
variable "PM_NODE" {
  default = env("PM_NODE")
}

source "proxmox-clone" "debian11-docker-template" {
  proxmox_url              = var.PM_API_URL
  username                 = var.PM_API_TOKEN_ID
  token                    = var.PM_API_TOKEN_SECRET
  insecure_skip_tls_verify = true
  node                     = var.PM_NODE
  clone_vm                 = "debian11-setup"
  ssh_username             = "james"

  template_description = "Podman Debian Image to use"
  template_name        = "debian11-docker-template"
}

build {
  description = "A template for building a docker cloud-init ready image"
  sources = [
    "source.proxmox-clone.debian11-docker-template"
  ]
  provisioner "shell" {
    inline = [
      "sudo apt update && sudo apt upgrade -y",
    ]
  }
  provisioner "shell" {
    scripts = [
      "scripts/setup-docker.sh"
      "scripts/cloud-ready.sh"
    ]
  }
}