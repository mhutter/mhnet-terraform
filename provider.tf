provider "hcloud" {
  version = "~> 1.23.0"
}

variable "gcloud_creds" {}
variable "gcloud_project" {}
provider "google" {
  version     = "~> 3.49.0"
  project     = var.gcloud_project
  credentials = file(var.gcloud_creds)
}
