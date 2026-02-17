resource "yandex_compute_disk" "vdisk" {
  count = 3

  name     = "vdisk-${count.index + 1}" 
  size     = 1
  type     = "network-hdd"
  zone     = var.default_zone
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
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
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.vdisk

    content {
      disk_id = secondary_disk.value.id
    }
  }

  metadata = local.full_metadata
}