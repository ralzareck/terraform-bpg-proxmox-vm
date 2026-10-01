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
# ===== Example - Basic Clone =================================================
# =============================================================================

# Minimum configuration required for successful clone of a Proxmox template.

module "pve_vm" {
  source = "../.."

  vm_type  = "image"
  pve_node = var.proxmox_node

  src_file = {
    datastore_id = "image"
    file_name    = "noble-server-cloudimg-amd64.img"
  }

  vm_name = "example-advanced-template"

  vm_start = {
    on_deploy = true
    on_boot   = true
    order     = 0
  }

  vm_agent = {
    enabled   = true
    type      = "virtio"
    wait_ipv4 = true
  }

  vm_cpu = {
    cores = 2
  }

  vm_mem = {
    dedicated = 4096
  }

  vm_bios = "ovmf"
  vm_efi_disk = {
    datastore_id = "data"
  }

  vm_disk = {
    scsi0 = {
      datastore_id = "data"
      size         = 8
      main_disk    = true
    }
  }

  vm_net_ifaces = {
    net0 = {
      bridge    = "vmbr0"
      ipv4_addr = "10.0.0.10/24"
      ipv4_gw   = "10.0.0.1"
    }
  }

  vm_init = {
    datastore_id = "local"
    interface    = "ide0"
    dns = {
      domain  = "home.internal"
      servers = ["8.8.8.8"]
    }
  }

  fw_opts = {
    enabled       = true
    macfilter     = true
    ipfilter      = true
    input_policy  = "DROP"
    output_policy = "ACCEPT"
  }

  fw_rules = [
    {
      enabled = true, direction = "in", action = "ACCEPT"
      iface   = "net0"
      proto   = "tcp"
      srcip   = "10.31.0.0/16"
      dstport = "22"
      comment = "Allow TCP connections to SSH port.", log = "info"
    },
    {
      enabled = true, direction = "in", action = "ACCEPT"
      iface   = "net0"
      proto   = "tcp"
      srcip   = "10.31.0.0/16"
      dstport = "443"
      comment = "Allow TCP connections to HTTPS port.", log = "nolog"
    }
  ]
}
