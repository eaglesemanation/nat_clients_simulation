resource "libvirt_volume" "server_volumes" {
  count = var.server_count

  name   = "server-volume-${count.index}"
  pool   = libvirt_pool.pool.name
  source = var.server_image
  format = "qcow2"
}

resource "libvirt_volume" "client_volumes" {
  count = var.client_count

  name   = "client-volume-${count.index}"
  pool   = libvirt_pool.pool.name
  source = var.client_image
  format = "qcow2"
}

resource "libvirt_volume" "router_volumes" {
  count = var.client_count

  name   = "router-volume-${count.index}"
  pool   = libvirt_pool.pool.name
  source = var.router_image
  format = "qcow2"
}
