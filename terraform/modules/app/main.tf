resource "google_compute_instance" "puma" {
  count = "${var.count_puma}"
  name = "puma-${var.stand}-${count.index}"
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
      agent        = false
      host         = "puma-${var.stand}-${count.index}"
      private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/mongo-db/mongo-${var.stand}/g' /home/tihomirovnv/app/reddit/app.rb"
    ]
  }
}
