output "vm_list" {
  description = "VM List Name, id, fqdn"
  value = flatten([
    [
      for i in yandex_compute_instance.web : {
        name = i.name
        id   = i.id
        fqdn = i.fqdn
      }
    ],
    [
      for i in values(yandex_compute_instance.db) : {
        name = i.name
        id   = i.id
        fqdn = i.fqdn
      }
    ],
    [
      {
        name = yandex_compute_instance.storage.name
        id   = yandex_compute_instance.storage.id
        fqdn = "${yandex_compute_instance.storage.name}${var.default_zone}.internal"
      }
    ]
  ])
}