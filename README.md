# nat_clients_simulation


## Description
Terraform module that sets up libvirt environment to test communication between clients behind NAT.

## Network layout
```
                      ┌────────────┐
                      │  Internet  │
                      │            │
                      │ (Host NAT) │
                      └──────┬─────┘
                             │
                             │
┌────────┐         ┌─────────┴──────────┐
│        │         │     WAN bridge     │
│ Server ├─────────┤                    │
│        │         │   (172.16.0.0/24)  │
└────────┘         └──────┬─────┬───────┘
                          │     │
                          │     │
                ┌─────────┘     └─────────┐
                │                         │
                │                         │
           ┌────┴────┐               ┌────┴────┐
           │         │               │         │
           │ Router1 │               │ Router2 │
           │         │               │         │
           └────┬────┘               └────┬────┘
                │                         │
                │                         │
     ┌──────────┴─────────┐     ┌─────────┴──────────┐
     │     LAN1 bridge    │     │     LAN2 bridge    │
     │                    │     │                    │
     │  (192.168.1.0/24)  │     │  (192.168.2.0/24)  │
     └──────────┬─────────┘     └─────────┬──────────┘
                │                         │
                │                         │
           ┌────┴────┐               ┌────┴────┐
           │         │               │         │
           │ Client1 │               │ Client2 │
           │         │               │         │
           └─────────┘               └─────────┘
```
Also each VM is connected to management bridge in 10.0.0.0/24 subnet for use it with configuration management such as Ansible

## Input

variable name          | type        | default value | description
-----------------------|-------------|---------------|------------
server_image           | string      |               | Path to OS image for server VM that supports Cloud-init
client_image           | string      |               | Path to OS image for client VM that supports Cloud-init
router_image           | string      |               | Path to OS image for router VM that supports Cloud-init, nftables and systemd-resolved
server_count           | number      | 1             | Defines how many server VMs connected to WAN bridge should be created
client_count           | number      | 2             | Defines how many pairs of client VMs and router VMs should be created
project_name           | string      | terraform     | Prefix for resources in libvirt
management_username    | string      | management    | Username for management user that has root access on all VM's for provisioning
management_ssh_pubkey  | string      |               | Public ssh key defined as '{algorithm} {key}'
management_ssh_port    | number      | 22            | _TODO: SSH port opened on management interface for all VMs_

## Output

It will return 3 lists of objects: **servers, routers, clients**. For example routers value could be
```tf
routers = [
  {
    "addresses" = {
      "lan" = "192.168.0.1"
      "management" = "10.0.0.5"
      "wan" = "172.16.0.2"
    }
    "instance" = "terraform_router-0"
    "port" = 22
    "user" = "management"
  },
  {
    "addresses" = {
      "lan" = "192.168.1.1"
      "management" = "10.0.0.6"
      "wan" = "172.16.0.3"
    }
    "instance" = "terraform_router-1"
    "port" = 22
    "user" = "management"
  },
]
```
