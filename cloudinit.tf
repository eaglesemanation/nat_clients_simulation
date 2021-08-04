data "template_file" "management_user_config" {
  vars = {
    management_username   = var.management_username
    management_ssh_pubkey = var.management_ssh_pubkey
  }

  template = file("${path.module}/templates/common_config.tpl")
}

data "template_file" "server_metadata" {
  count = var.server_count
  vars  = {
    hostname = "server-${count.index}"
  }

  template = file("${path.module}/templates/instance_metadata.tpl")
}

data "template_file" "server_network_config" {
  count = var.server_count
  vars  = {
    management_ipv4_address = local.management_ipv4_addresses[count.index]
  }

  template = file("${path.module}/templates/server_network_config.tpl")
}

resource "libvirt_cloudinit_disk" "server_init" {
  count = var.server_count

  name           = "server-${count.index}-init.iso"
  user_data      = format("#cloud-config\n---\n%s",
    yamlencode(merge(
      yamldecode(data.template_file.management_user_config.rendered),
      yamldecode(data.template_file.server_metadata[count.index].rendered)
    ))
  )
  network_config = data.template_file.server_network_config[count.index].rendered
  pool           = libvirt_pool.pool.name
}

data "template_file" "client_metadata" {
  count = var.client_count
  vars  = {
    hostname = "client-${count.index}"
  }

  template = file("${path.module}/templates/instance_metadata.tpl")
}

data "template_file" "client_network_config" {
  count = var.client_count
  vars  = {
    ipv4_address            = "192.168.${count.index}.10/24"
    ipv4_gateway            = "192.168.${count.index}.1"
    management_ipv4_address = local.management_ipv4_addresses[var.server_count + count.index]
  }

  template = file("${path.module}/templates/client_network_config.tpl")
}

resource "libvirt_cloudinit_disk" "client_init" {
  count = var.client_count

  name           = "client-${count.index}-init.iso"
  user_data      = format("#cloud-config\n---\n%s",
    yamlencode(merge(
      yamldecode(data.template_file.management_user_config.rendered),
      yamldecode(data.template_file.client_metadata[count.index].rendered)
    ))
  )
  network_config = data.template_file.client_network_config[count.index].rendered
  pool           = libvirt_pool.pool.name
}

data "template_file" "router_metadata" {
  count = var.client_count
  vars  = {
    hostname = "router-${count.index}"
  }

  template = file("${path.module}/templates/instance_metadata.tpl")
}

data "template_file" "router_network_config" {
  count = var.client_count
  vars  = {
    ipv4_address            = "192.168.${count.index}.1/24"
    management_ipv4_address = local.management_ipv4_addresses[var.server_count + var.client_count + count.index]
  }

  template = file("${path.module}/templates/router_network_config.tpl")
}

data "template_file" "router_nat_config" {
  count = var.client_count
  vars  = {
    ipv4_lan_address = "192.168.${count.index}.1"
  }

  template = file("${path.module}/templates/router_nat_config.tpl")
}

resource "libvirt_cloudinit_disk" "router_init" {
  count = var.client_count

  name           = "router-${count.index}-init.iso"
  user_data      = format("#cloud-config\n---\n%s",
    yamlencode(merge(
      yamldecode(data.template_file.management_user_config.rendered),
      yamldecode(data.template_file.router_metadata[count.index].rendered),
      yamldecode(data.template_file.router_nat_config[count.index].rendered)
    ))
  )
  network_config = data.template_file.router_network_config[count.index].rendered
  pool           = libvirt_pool.pool.name
}
