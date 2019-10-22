terraform {
backend "gcs" {
  bucket  = "storage-ntikhomirovt"
  path  = "terraform/prod/terraform.tfvars"
  location = "europe-west4"
}
}
