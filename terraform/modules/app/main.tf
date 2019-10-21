resource "google_compute_instance" "puma" {
  count = "${var.count_puma}"
  name = "puma-${stand}-${count.index}"
  machine_type = "f1-micro"
  zone = "${var.region}"
  boot_disk {
    initialize_params {
      image = "${var.image_name.puma}"
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
      agent        = true
      host         = self.network_interface[0].access_config[0].nat_ip
      private_key = "${file(var.private_key_path)}"
      host         = "puma"
      port         = 22
      bastion_host = "otus.nt33.ru"
      bastion_user = "tihomirovnv"
      bastion_port = 22
      private_key = "${file(var.private_key_path)}"
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
