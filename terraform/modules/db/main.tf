resource "google_compute_instance" "mongo" {
  name = "mongo-${var.stand}"
  machine_type = "f1-micro"
  zone = "${var.region}"
  tags = ["db",,"${var.stand}"]
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

}
