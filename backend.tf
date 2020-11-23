terraform {
  backend "s3" {
    bucket   = "mhnet-terraform-state"
    key      = "state"
    endpoint = "https://objects.lpg.cloudscale.ch"
    region   = "eu-central-1"

    # cloudscale specifics
    skip_credentials_validation = true
  }
}
