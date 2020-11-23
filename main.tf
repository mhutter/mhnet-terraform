resource "hcloud_ssh_key" "default" {
  name       = "default"
  public_key = var.ssh_public_key
}

resource "hcloud_network" "internal" {
  name     = "internal"
  ip_range = "10.0.0.0/16"
}
resource "hcloud_network_subnet" "internal" {
  network_id   = hcloud_network.internal.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/24"
}
