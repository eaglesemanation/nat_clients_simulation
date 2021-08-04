output "servers" {
  value = [
    for server in libvirt_domain.server: {
      instance  = server.name
      addresses = {
        management = one([
          for interface in server.network_interface:
            interface.addresses
            if interface.network_name == libvirt_network.management.name
        ][0])
        wan        = one([
          for interface in server.network_interface:
            interface.addresses
            if interface.network_name == libvirt_network.wan.name
        ][0])
      }
      user      = var.management_username
      port      = var.management_ssh_port
    }
  ]
}

output "clients" {
  value = [
    for idx, client in libvirt_domain.client: {
      instance  = client.name
      addresses = {
        management = one([
          for interface in client.network_interface:
            interface.addresses
            if interface.network_name == libvirt_network.management.name
        ][0])
        lan = one([
          for interface in client.network_interface:
            interface.addresses
            if interface.network_name == libvirt_network.lan[idx].name
        ][0])
      }
      user      = var.management_username
      port      = var.management_ssh_port
    }
  ]
}

output "routers" {
  value = [
    for idx, router in libvirt_domain.router: {
      instance  = router.name
      addresses = {
        management = one([
          for interface in router.network_interface:
            interface.addresses
            if interface.network_name == libvirt_network.management.name
        ][0])
        wan        = one([
          for interface in router.network_interface:
            interface.addresses
            if interface.network_name == libvirt_network.wan.name
        ][0])
        lan        = one([
          for interface in router.network_interface:
            interface.addresses
            if interface.network_name == libvirt_network.lan[idx].name
        ][0])
      }
      user      = var.management_username
      port      = var.management_ssh_port
    }
  ]
}
