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

source "proxmox-clone" "vm-template" {
  proxmox_url              = var.PM_API_URL
  username                 = var.PM_API_TOKEN_ID
  token                    = var.PM_API_TOKEN_SECRET
  insecure_skip_tls_verify = true
  node                     = var.PM_NODE
  memory                   = 2048
  os                       = "l26"
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }
  scsi_controller = "virtio-scsi-pci"
  full_clone      = true
  clone_vm        = "ubuntu2004-setup"
  ssh_username    = "james"

  template_description = "Docker Ubuntu Image to use"
  template_name        = "ubuntu11-docker-template"
}

build {
  description = "A template for building a docker cloud-init ready image"
  sources = [
    "source.proxmox-clone.vm-template"
  ]
  provisioner "shell" {
    inline = [
      "sudo apt update && sudo apt upgrade -y",
    ]
  }
  provisioner "shell" {
    scripts = [
      "scripts/setup-docker.sh",
      "scripts/cloud-ready.sh"
    ]
  }
}
