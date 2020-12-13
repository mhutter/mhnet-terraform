provider "hcloud" {}

variable "gcloud_creds" {}
variable "gcloud_project" {}
provider "google" {
  project     = var.gcloud_project
  credentials = file(var.gcloud_creds)
}
