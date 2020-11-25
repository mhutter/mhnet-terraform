locals {
  domain       = trimsuffix(data.google_dns_managed_zone.mhnet.dns_name, ".")
  bastion_fqdn = "bastion.${var.location}.${local.domain}"
}

data "cloudinit_config" "bastion" {
  # Default config
  part {
    content = templatefile("${path.module}/templates/cloud-config.yml", {
      fqdn        = local.bastion_fqdn,
      floating_ip = hcloud_floating_ip.bastion.ip_address
    })
  }

  # configure floating IP
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/floating-ip.sh", {
      floating_ip = hcloud_floating_ip.bastion.ip_address
    })
  }

  # allow SSH from ANY address
  part {
    content_type = "text/x-shellscript"
    content      = "ufw allow ssh"
  }
}

resource "hcloud_floating_ip" "bastion" {
  type          = "ipv4"
  home_location = var.location
}

resource "hcloud_server" "bastion" {
  name        = local.bastion_fqdn
  image       = data.hcloud_image.base.id
  server_type = "cx11"
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  user_data   = cloudinit_config.bastion.rendered
}

resource "hcloud_server_network" "bastion" {
  server_id  = hcloud_server.bastion.id
  network_id = hcloud_network.internal.id
  ip         = "10.0.0.2"
}

resource "hcloud_floating_ip_assignment" "bastion" {
  floating_ip_id = hcloud_floating_ip.bastion.id
  server_id      = hcloud_server.bastion.id
}

resource "google_dns_record_set" "bastion" {
  name    = "${local.bastion_fqdn}."
  type    = "A"
  ttl     = 300
  rrdatas = [hcloud_server_network.bastion.ip]

  managed_zone = data.google_dns_managed_zone.mhnet.name
}
