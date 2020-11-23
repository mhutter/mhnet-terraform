
resource "hcloud_floating_ip" "bastion" {
  type          = "ipv4"
  home_location = "fsn1"
}

resource "hcloud_server" "bastion" {
  name        = "bastion.mhnet.me"
  image       = data.hcloud_image.base.id
  server_type = "cx11"
  location    = "fsn1"
  ssh_keys    = [hcloud_ssh_key.default.id]
  user_data = templatefile(
    "${path.module}/templates/cloud-config.yml",
    {
      fqdn        = "bastion.mhnet.me"
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
