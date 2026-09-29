# Copyright 2025 RalZareck
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# =============================================================================
# ===== Provider ==============================================================
# =============================================================================

terraform {
  required_version = "~> 1.9"
}

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.114.0"
    }
  }
}

provider "proxmox" {
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  endpoint  = "https://${var.proxmox_host}/api2/json"
  insecure  = true
  ssh {
    agent       = false
    private_key = file(var.proxmox_ssh_private_key)
    username    = "root"
  }
}
