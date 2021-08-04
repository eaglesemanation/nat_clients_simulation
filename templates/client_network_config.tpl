# TODO: match interfaces by mac-address
---
version: 2
ethernets:
  ens3: # LAN
    addresses:
      - ${ipv4_address}
    %{if ipv4_gateway != ""}
    gateway4: ${ipv4_gateway}
    nameservers:
      addresses:
        - ${ipv4_gateway}
    %{endif}
  ens4: # Management
    addresses:
      - ${management_ipv4_address}

# vim: syntax=yaml
