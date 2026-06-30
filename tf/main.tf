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

  cloud_init = <<-EOT
    # cloud-config
    apt:
      primary:
        - arches: [default]
          uri: "http://nexus.home.local/repository/ubuntu-archive"
    bootcmd:
      - [mkdir, "-p", "/etc/systemd/resolved.conf.d/"]
      - printf "[Resolve]\nDNS=192.168.0.193 192.168.0.120\nDomains=~.\n" > /etc/systemd/resolved.conf.d/dns_servers.conf
      - [systemctl, restart, systemd-resolved]

    packages:
      - git
      - screen
      - vim
      - stow

    EOT
}

resource "multipass_alias" "shell" {
  name     = "dev-shell"
  instance = multipass_instance.dev.name
  command  = "bash"
}

output "dev_ip" {
  value = multipass_instance.dev.ipv4
}
