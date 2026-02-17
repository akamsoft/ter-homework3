locals {
  full_metadata = merge(var.vms_metadata, { ssh-keys = file("~/.ssh/id_ed25519.pub") })
}