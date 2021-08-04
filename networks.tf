resource "libvirt_network" "management" {
  name      = "${var.project_name}_management"
  mode      = "nat"
  addresses = ["10.0.0.0/24"]

  // Don't add default gateway on management network, it should only be used for SSH
  dhcp {
    enabled = false
  }
}

locals {
  management_ipv4_addresses = [
    for index in range(var.server_count + var.client_count * 2):
      "10.0.0.${index + 2}/24"
    ]
}

resource "libvirt_network" "wan" {
  name      = "${var.project_name}_wan"
  mode      = "nat"
  addresses = ["172.16.0.0/24"]

  dns {
    enabled = true
  }
}

resource "libvirt_network" "lan" {
  count = var.client_count

  name      = "${var.project_name}_lan-${count.index}"
  mode      = "none"
  addresses = ["192.168.${count.index}.0/24"]
}
