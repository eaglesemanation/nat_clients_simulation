---
users:
  - name: ${management_username}
    sudo:
      - ALL=(ALL) NOPASSWD:ALL
    %{if management_ssh_pubkey != ""}
    ssh_authorized_keys:
      - ${management_ssh_pubkey}
    %{endif}
    shell: /usr/bin/bash

package_upgrade: True
package_reboot_if_required: True

# vim: syntax=yaml
