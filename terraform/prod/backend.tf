provider "google" {

  version = "2.15"

  project = "${var.project_id}"

  region = "${var.region}"

}

terraform {
backend "gcs" {
  bucket  = "storage-ntikhomirovt"
  path  = "terraform/prod/terraform.tfvars"
}
}
