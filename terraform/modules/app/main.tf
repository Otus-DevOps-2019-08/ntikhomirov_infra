resource "google_compute_instance" "puma" {
  count = "${var.count_puma}"
  name = "puma-${stand}-${count.index}"
  machine_type = "f1-micro"
  zone = "${var.region}"
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
      agent        = true
      host         = self.network_interface[0].access_config[0].network
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
      "sed -i 's/mongo-db/mongo-${stand}/g' /home/tihomirovnv/app/reddit/app.rb"
    ]
  }
}
