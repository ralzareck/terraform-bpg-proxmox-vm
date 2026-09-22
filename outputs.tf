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
# ===== Outputs ===============================================================
# =============================================================================

output "pve_node" {
  description = "Name of the Proxmox Node."
  value       = resource.proxmox_virtual_environment_vm.pve_vm.node_name
}

output "pve_id" {
  description = "Proxmox ID of the instance."
  value       = resource.proxmox_virtual_environment_vm.pve_vm.vm_id
}

output "pve_pool" {
  description = "Proxmox Pool of the instance."
  value       = resource.proxmox_virtual_environment_vm.pve_vm.pool_id
}

output "pve_type" {
  description = "Proxmox type of virtualization."
  value       = "qemu"
}

output "name" {
  description = "Name of the instance."
  value       = resource.proxmox_virtual_environment_vm.pve_vm.name
}

output "cpu" {
  description = "Number of CPU of the instance."
  value       = resource.proxmox_virtual_environment_vm.pve_vm.cpu[0].cores
}

output "mem" {
  description = "Memory size of the instance."
  value       = resource.proxmox_virtual_environment_vm.pve_vm.memory[0].dedicated
}

output "bios" {
  description = "BIOS of the instance."
  value       = resource.proxmox_virtual_environment_vm.pve_vm.bios
}

output "disk" {
  description = "Disk information of the instance. Contains `datastore_id`, `format`, `path`, `interface` and `size` of the disk."
  value = [
    for disk in proxmox_virtual_environment_vm.pve_vm.disk :
    {
      datastore_id = disk.datastore_id
      format       = disk.file_format
      path         = disk.path_in_datastore
      interface    = disk.interface
      size         = disk.size
    }
  ]
}

output "efi_disk" {
  description = "EFI Disk information of the instance. Contains `datastore_id`, `format`, `pre_enrolled_keys` and `size` of the disk."
  value = [
    for efi_disk in proxmox_virtual_environment_vm.pve_vm.efi_disk :
    {
      datastore_id      = efi_disk.datastore_id
      format            = efi_disk.file_format
      pre_enrolled_keys = efi_disk.pre_enrolled_keys
      size              = efi_disk.type
    }
  ]
}

output "iface" {
  description = "List of iface of the instance (excluding the `lo` iface)."
  value = [
    for idx, name in proxmox_virtual_environment_vm.pve_vm.network_interface_names :
    name
    if name != "lo" && length(proxmox_virtual_environment_vm.pve_vm.ipv4_addresses[idx]) > 0
  ]
}

output "ip" {
  description = "Couple iface => List of IP of the instance"
  value = {
    for idx, name in proxmox_virtual_environment_vm.pve_vm.network_interface_names :
    name => [
      for ip in proxmox_virtual_environment_vm.pve_vm.ipv4_addresses[idx] :
      split("/", ip)[0]
    ]
    if name != "lo" && length(proxmox_virtual_environment_vm.pve_vm.ipv4_addresses[idx]) > 0
  }
}

output "ipv6_addresses" {
  description = "Couple iface => List of IPv6 of the instance"
  value = {
    for idx, name in proxmox_virtual_environment_vm.pve_vm.network_interface_names :
    name => [
      for ip in proxmox_virtual_environment_vm.pve_vm.ipv6_addresses[idx] :
      split("/", ip)[0]
    ]
    if name != "lo" && length(proxmox_virtual_environment_vm.pve_vm.ipv6_addresses[idx]) > 0
  }
}
