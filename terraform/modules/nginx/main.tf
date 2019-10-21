resource "google_compute_instance" "nginx" {
  name = "nginx-${var.stand}"
  machine_type = "f1-micro"
  zone = "${var.region}"
  tags = ["reddit-nginx"]
  boot_disk {
    initialize_params {
      image = "${var.image_name}"
    }
  }

  network_interface {
    network = "default"

  }

  metadata = {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}"

  }

  connection {
      type         = "ssh"
      user         = "tihomirovnv"
      agent        = false
      host         = "nginx-${var.stand}"
      private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "modules/files/nginx.py"
    destination = "/tmp/nginx.py"
  }

  provisioner "file" {
    source      = "modules/files/monitor.py"
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
