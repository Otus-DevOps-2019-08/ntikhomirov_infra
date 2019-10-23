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
