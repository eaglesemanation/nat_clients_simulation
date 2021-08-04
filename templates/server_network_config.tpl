# TODO: match interfaces by mac-address
---
version: 2
ethernets:
  ens3: # WAN
    dhcp4: true
  ens4: # Management
    addresses:
      - ${management_ipv4_address}

# vim: syntax=yaml
