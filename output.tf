output "bastion_ip" {
  value = hcloud_floating_ip.bastion.ip_address
}
