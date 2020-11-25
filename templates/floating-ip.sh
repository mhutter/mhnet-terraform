#!/bin/bash
set -e -u -o pipefail

cat > /etc/netplan/60-floating-ip.yaml <<EOT
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - ${floating_ip}/32
EOT

netplan apply
