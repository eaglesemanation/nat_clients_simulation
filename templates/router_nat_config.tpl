---
packages:
  - nftables

write_files:
  - path: /etc/sysctl.d/99-ip-forwarding.conf
    content: |
      net.ipv4.ip_forward = 1
      net.ipv6.conf.default.forwarding = 1

  - path: /etc/nftables.conf
    content: |
      table ip nat {
        chain postrouting {
          type nat hook postrouting priority 100;
          oifname {ens3} masquerade
        }
      }

  - path: /etc/systemd/resolved.conf
    content: |
      [Resolve]
      DNSStubListener=yes
      DNSStubListenerExtra=${ipv4_lan_address}

runcmd:
  - systemctl enable --now nftables
  - systemctl restart systemd-resolved
  - sysctl --system


# vim: syntax=yaml
