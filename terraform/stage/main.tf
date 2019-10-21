terraform {
  # Версия terraform
  required_version = "~>0.12.6"
}

provider "google" {

  version = "2.15"
  project = "${var.project_id}"
  region = "${var.region}"
}