terraform {
  # Версия terraform
  required_version = "~>0.12.6"
}

provider "google" {

  version = "2.15"
  project = "${var.project_id}"
  region = "${var.region}"
}

#Создаем правила фаервола (отклонение от ДЗ)
resource "google_compute_firewall" "firewall_nginx" {
  name = "allow-nginx-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-nginx"]
}


resource "google_compute_instance" "mongo" {
  name = "mongo"
  machine_type = "f1-micro"
  zone = "${var.region}"
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
    ssh-keys = "appuser:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}"
  }

}

resource "google_compute_instance" "puma" {
  count = "${var.count_puma}"
  name = "puma-${count.index}"
  machine_type = "f1-micro"
  zone = "${var.region}"
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
    ssh-keys = "appuser:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}"

  }
}


resource "google_compute_instance" "nginx" {
  name = "nginx"
  machine_type = "f1-micro"
  zone = "${var.region}"
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
    ssh-keys = "appuser:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}"

  }

  connection {
      type         = "ssh"
      user         = "tihomirovnv"
      agent        = false
      host         = self.network_interface[0].access_config[0].nat_ip
      private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/nginx.py"
    destination = "/tmp/nginx.py"
  }

  provisioner "file" {
    source      = "files/monitor.py"
    destination = "/tmp/monitor.py"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.py",
      "python /tmp/nginx.py ${var.count_puma}",
      "sudo cp /tmp/upstream.conf /etc/nginx/conf.d/",
      "sed -i 's/COUNT_ID/${var.count_puma}/g' /tmp/monitor.py",
      "sudo cp /tmp/monitor.py /opt/www/monitor/cgi-bin",
      "sudo chown -R www-data:www-data /opt/www/monitor/cgi-bin/monitor.py",
      "sudo systemctl start nginx"
    ]
  }

}
