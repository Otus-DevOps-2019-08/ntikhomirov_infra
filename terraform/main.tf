terraform {
  # Версия terraform
  required_version = "0.12.10"
}

provider "google" {

  version = "2.15"
  project = "indigo-almanac-254221"
  region = "europe-west4-a"
}

resource "google_compute_instance" "app" {
  name = "nginx"
  machine_type = "f1-micro"
  zone = "europe-west4-a"
  boot_disk {
    initialize_params {
<<<<<<< HEAD
      image = "ubuntu-nginx-1571125476"
=======
      image = "ubuntu-nginx-ntikhomirov"
>>>>>>> 522095bfc50da1b78017668aac38f0edb3fae732
    }
  }

  network_interface {
    network = "default"
    access_config {
        nat_ip = "otus"
    }
  }
}
