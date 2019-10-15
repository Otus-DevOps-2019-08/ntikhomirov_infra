terraform {
  # Версия terraform
  required_version = "0.12.10"
}

provider "google" {

  version = "2.15"
  project = "indigo-almanac-254221"
  region = "europe-west4-a"
}


resource "google_compute_instance" "mongo" {
  name = "mongo"
  machine_type = "f1-micro"
  zone = "europe-west4-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-mongodb-ntikhomirov"
    }
  }

  network_interface {
    network = "default"
    access_config{
    }
  }
}

resource "google_compute_instance" "puma1" {
  name = "puma1"
  machine_type = "f1-micro"
  zone = "europe-west4-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-puma-ntikhomirov"
    }
  }

  network_interface {
    network = "default"
    access_config{
    }
  }
}

resource "google_compute_instance" "puma2" {
  name = "puma2"
  machine_type = "f1-micro"
  zone = "europe-west4-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-puma-ntikhomirov"
    }
  }

  network_interface {
    network = "default"
    access_config{
    }
  }
}


resource "google_compute_instance" "nginx" {
  name = "nginx"
  machine_type = "f1-micro"
  zone = "europe-west4-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-nginx-ntikhomirov"
    }
  }

  network_interface {
    network = "default"
    access_config{
    }
  }
}
