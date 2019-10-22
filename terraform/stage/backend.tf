terraform {
backend "gcs" {
  bucket  = "storage-ntikhomirov"
  path  = "terraform/stage/terraform.tfvars"
}
}
