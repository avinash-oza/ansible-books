terraform {
  required_providers {
    multipass = {
      source  = "todoroff/multipass"
      version = ">= 1.4.0"
    }
  }
}

provider "multipass" {
  # Optional overrides
# multipass_path  = "/usr/bin/multipass"
  command_timeout = 180          # seconds
  default_image   = "24.04"        # fallback image alias
}
