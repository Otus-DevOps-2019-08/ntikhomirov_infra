resource "google_compute_instance" "nginx" {
  name = "nginx-${var.stand}"
  machine_type = "f1-micro"
  zone = "${var.region}"
  tags = ["proxy","${var.stand}"]
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
