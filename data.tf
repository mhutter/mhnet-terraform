data "hcloud_image" "base" {
  with_selector = "mhnet-image=base"
  most_recent   = true
}

data "google_dns_managed_zone" "mhnet" {
  name = "mhnet-me"
}
