resource "google_compute_instance" "nginx" {
  name = "nginx"
  machine_type = "f1-micro"
  zone = "${var.region}"
  tags = ["http-server","https-server","reddit-nginx"]
  boot_disk {
    initialize_params {
      image = "${var.image_name}"
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
