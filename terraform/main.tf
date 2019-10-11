terraform {
  # Версия terraform
  required_version = "0.12.10"
}

provider "google" {
  # Версия провайдера
  version = "2.15"

  # ID проекта
  project = "indigo-almanac-254221"

  region = "europe-west4-a"
}

resource "google_compute_instance" "app" {
  name = "nginx"
  machine_type = "f1-micro"
  zone = "europe-west4-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-nginx-1570710004"
    }
  }
  
  network_interface {
    network = "default"
    access_config {}
  }
}