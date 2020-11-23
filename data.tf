data "hcloud_image" "base" {
  with_selector = "mhnet-image=base"
  most_recent   = true
}
