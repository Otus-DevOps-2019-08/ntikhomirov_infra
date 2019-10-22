terraform {
backend "gcs" {
  bucket  = "storage-ntikhomirov"
  path  = "terraform/prod/terraform.tfvars"
}
}
