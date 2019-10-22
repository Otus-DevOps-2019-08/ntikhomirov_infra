terraform {
backend "gcs" {
  bucket  = "storage-ntikhomirovt"
  prefix  = "terraform/prod/terraform.tfvars"
}
}
