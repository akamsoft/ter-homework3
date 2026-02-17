resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}" 
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.id
    }
  }
  
  scheduling_policy {
    preemptible = true  # Использую preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  
  depends_on = [yandex_compute_instance.db] 
  
  metadata = local.full_metadata
}