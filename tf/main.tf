resource "multipass_instance" "dev" {
  name   = "dev-box"
  cpus   = 2
  memory = "4G"
  disk   = "5G"

  networks {
    name = "virbr0"
    mode = "manual"
    mac  = "52:54:00:4b:ab:bd"
  }

  cloud_init_file = "${path.module}/cloud-init.yaml"
}

output "dev_ip" {
  value = multipass_instance.dev.ipv4
}
