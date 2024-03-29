provider "google" {
  version = "~> 2.15"
  project = "${var.project_id}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.3.0"
  # Имя
  name = "storage-ntikhomirov"
  location = "${var.zone}"

}

output storage-bucket_url {
  value = module.storage-bucket.url
}
