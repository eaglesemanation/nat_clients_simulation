terraform {
  required_version = ">= 0.15"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.6.10"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "pool" {
  name = "${var.project_name}_pool"
  type = "dir"
  path = "/tmp/${var.project_name}_pool"
}
