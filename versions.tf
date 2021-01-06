terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.51.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.23.0"
    }
  }
}
