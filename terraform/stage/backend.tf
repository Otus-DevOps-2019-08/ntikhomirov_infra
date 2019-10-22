terraform {
backend "gcs" {
  bucket  = "storage-ntikhomirov"
  prefix  = "terraform/stage/terraform.tfvars"
}
}
