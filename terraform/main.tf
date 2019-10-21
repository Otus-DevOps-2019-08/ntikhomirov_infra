terraform {
  # Версия terraform
  required_version = "~>0.12.6"
}

provider "google" {

  version = "2.15"

  project = "${var.project_id}"

  region = "${var.region}"

}

module "mongodb" {
  source = "./modules/db"

  image_name = "${var.image_name.mongo}"

  region = "${var.region}"

  public_key_path = "${var.public_key_path}"

}

module "puma" {
  source = "./modules/app"

  image_name = "${var.image_name.puma}"

  region = "${var.region}"

  public_key_path = "${var.public_key_path}"

  private_key_path = "${var.private_key_path}"

  count_puma = "${var.count_puma}"

}

module "nginx" {
  source = "./modules/nginx"

  image_name = "${var.image_name.nginx}"

  region = "${var.region}"

  private_key_path = "${var.private_key_path}"

  count_puma = "${var.count_puma}"

}
