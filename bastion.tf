locals {
  bastion_fqdn = "bastion.${var.location}.${data.google_dns_managed_zone.mhnet.dns_name}"
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
  user_data = templatefile(
    "${path.module}/templates/cloud-config.yml",
    {
      fqdn        = local.bastion_fqdn
      floating_ip = hcloud_floating_ip.bastion.ip_address
    },
  )
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
  name    = local.bastion_fqdn
  type    = "A"
  ttl     = 300
  rrdatas = [hcloud_server_network.bastion.ip]

  managed_zone = data.google_dns_managed_zone.mhnet.name
}
