terraform {
  # Версия terraform
  required_version = "0.12.10"
}

provider "google" {

  version = "2.15"
  project = "indigo-almanac-254221"
  region = "europe-west4-a"
}


resource "google_compute_firewall" "firewall_nginx" {
  name = "allow-nginx-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-nginx"]
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
  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file("/home/ntikhomirov/.ssh/appuser.pub")}\nappuser2:${file("/home/ntikhomirov/.ssh/appuser2.pub")}"
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
  }
  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file("/home/ntikhomirov/.ssh/appuser.pub")}\nappuser2:${file("/home/ntikhomirov/.ssh/appuser2.pub")}"
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
  }
  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file("/home/ntikhomirov/.ssh/appuser.pub")}\nappuser2:${file("/home/ntikhomirov/.ssh/appuser2.pub")}"
  }

  connection {
      type         = "ssh"
      user         = "ntikhomirov"
      agent        = true
      host         = "puma2"
      port         = 22
      bastion_host = "otus.nt33.ru"
      bastion_user = "ntikhomirov"
      bastion_port = 22
      private_key = "${file("/home/ntikhomirov/.ssh/ntikhomirov")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

}



resource "google_compute_instance" "nginx" {
  name = "nginx"
  machine_type = "f1-micro"
  zone = "europe-west4-a"
  tags = ["http-server","https-server","reddit-nginx"]
  boot_disk {
    initialize_params {
      image = "ubuntu-nginx-ntikhomirov"
    }
  }

  network_interface {
    network = "default"
    access_config{
        nat_ip = "34.90.19.140"
        network_tier =  "PREMIUM"
        public_ptr_domain_name = ""
     }

  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file("/home/ntikhomirov/.ssh/appuser.pub")}\nappuser2:${file("/home/ntikhomirov/.ssh/appuser2.pub")}"
  }

}
