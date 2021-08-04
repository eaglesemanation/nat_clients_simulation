resource "libvirt_domain" "server" {
  count = var.server_count

  name   = "${var.project_name}_server-${count.index}"
  memory = "512"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.server_init[count.index].id

  network_interface {
    network_name = libvirt_network.wan.name
    addresses    = ["172.16.0.${count.index + 10}"]
  }

  network_interface {
    network_name = libvirt_network.management.name
    addresses    = [
      split("/", local.management_ipv4_addresses[count.index])[0]
    ]
  }

  disk {
    volume_id = libvirt_volume.server_volumes[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_port = "1"
    target_type = "virtio"
  }
}

resource "libvirt_domain" "client" {
  count = var.client_count

  name   = "${var.project_name}_client-${count.index}"
  memory = "512"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.client_init[count.index].id

  network_interface {
    network_name = libvirt_network.lan[count.index].name
    addresses    = ["192.168.${count.index}.10"]
  }

  network_interface {
    network_name = libvirt_network.management.name
    addresses    = [
      split("/", local.management_ipv4_addresses[var.server_count + count.index])[0]
    ]
  }

  disk {
    volume_id = libvirt_volume.client_volumes[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_port = "1"
    target_type = "virtio"
  }
}

resource "libvirt_domain" "router" {
  count = var.client_count

  name   = "${var.project_name}_router-${count.index}"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.router_init[count.index].id

  network_interface {
    network_name = libvirt_network.wan.name
    addresses    = ["172.16.0.${count.index + 2}"]
  }

  network_interface {
    network_name = libvirt_network.lan[count.index].name
    addresses    = ["192.168.${count.index}.1"]
  }

  network_interface {
    network_name = libvirt_network.management.name
    addresses    = [
      split("/", local.management_ipv4_addresses[var.server_count + var.client_count + count.index])[0]
    ]
  }

  disk {
    volume_id = libvirt_volume.router_volumes[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_port = "1"
    target_type = "virtio"
  }
}
