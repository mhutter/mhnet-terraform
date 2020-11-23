resource "hcloud_ssh_key" "default" {
  name       = "default"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfm1yYW1eWfyHGTHVgtgP2P2yY5otmHnSWUWEyNk23f"
}

resource "hcloud_network" "internal" {
  name     = "mhnet"
  ip_range = "10.0.0.0/16"
}
resource "hcloud_network_subnet" "internal" {
  network_id   = hcloud_network.internal.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/24"
}
