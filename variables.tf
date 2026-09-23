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
# ===== General ===============================================================
# =============================================================================

variable "pve_node" {
  type        = string
  description = "PVE Node name on which the VM will be created on."

  validation {
    condition     = can(regex("[A-Za-z0-9.-]{1,63}", var.pve_node))
    error_message = "This var is constrained by the node name requirements set forth by ProxMox."
  }
}

variable "vm_type" {
  type        = string
  description = "The source type used for the creation of the container. Can either be 'clone' or 'image'."

  validation {
    condition     = contains(["clone", "image"], var.vm_type)
    error_message = "Valid values for var: vm_type are (clone, image)."
  }
}

variable "src_clone" {
  type = object({
    datastore_id = string
    node_name    = optional(string)
    tpl_id       = number
  })
  description = "The target to clone as base for the VM. Cannot be used with 'src_file'"
  nullable    = true
  default     = null
}

variable "src_file" {
  type = object({
    datastore_id = string
    file_name    = string
  })
  description = "The target ISO file to use as base for the VM. Cannot be used with 'src_clone'"
  nullable    = true
  default     = null
}

# =============================================================================
# ===== VM ====================================================================
# =============================================================================

variable "vm_name" {
  type        = string
  description = "The name of the VM."
}

variable "vm_id" {
  type        = number
  description = "The ID of the VM."
  nullable    = true
  default     = null
}

variable "vm_description" {
  type        = string
  description = "The description of the VM."
  nullable    = true
  default     = null
}

variable "vm_pool" {
  type        = string
  description = "The Pool in which to place the VM."
  nullable    = true
  default     = null

  validation {
    condition     = can(regex("[A-Za-z0-9_-]{0,63}", var.vm_pool)) || var.vm_pool == null
    error_message = "This variable is constrained by the pool name requirements set forth by ProxmoxVE."
  }
}

variable "vm_tags" {
  type        = list(string)
  description = "A list of tags associated to the VM."
  default     = []
}

variable "vm_start" {
  type = object({
    on_deploy  = bool
    on_boot    = bool
    order      = optional(number, 0)
    up_delay   = optional(number, 0)
    down_delay = optional(number, 0)
  })
  description = "The start settings of the VM."
  default = {
    on_deploy  = true
    on_boot    = true
    order      = 0
    up_delay   = 0
    down_delay = 0
  }
}

variable "vm_agent" {
  type = object({
    enabled = optional(bool)
    type    = optional(string, "virtio")
  })
  description = "The QEMU guest agent settings of the VM"
  default = null
  nullable = true
}

variable "vm_bios" {
  type        = string
  description = "The BIOS Implementation of the VM. Can either be 'seabios' or 'ovmf'."
  default     = "seabios"

  validation {
    condition     = contains(["ovmf", "seabios"], var.vm_bios)
    error_message = "Valid values for var: vm_bios are (ovmf, seabios)."
  }
}

variable "vm_machine" {
  type        = string
  description = "The machine type of the VM."
  default     = "q35"

  validation {
    condition     = contains(["pc", "q35"], var.vm_machine)
    error_message = "Valid values for var: vm_machine are (pc, q35)."
  }
}

variable "vm_scsi_hardware" {
  type        = string
  description = "The SCSI hardware type of the VM."
  default     = "virtio-scsi-single"

  validation {
    condition     = contains(["lsi", "lsi53c810", "virtio-scsi-pci", "virtio-scsi-single", "megasas", "pvscsi"], var.vm_scsi_hardware)
    error_message = "Valid values for var: vm_scsi_hardware are (lsi, lsi53c810, virtio-scsi-pci, virtio-scsi-single, megasas, pvscsi)."
  }
}

variable "vm_os" {
  type        = string
  description = "The Operating System configuration of the VM."
  default     = "l26"

  validation {
    condition     = contains(["l24", "l26", "other", "solaris", "w2k", "w2k3", "w2k8", "win7", "win8", "win10", "win11", "wvista", "wxp"], var.vm_os)
    error_message = "Valid values for var: vm_os are (l24, l26, other, solaris, w2k, w2k3, w2k8, win7, win8, win10, win11, wvista, wxp)."
  }
}

variable "vm_cpu" {
  type = object({
    type  = optional(string, "host")
    cores = optional(number, 2)
    units = optional(number)
  })
  description = "The CPU Configuration of the VM."
  default     = {}
}

variable "vm_mem" {
  type = object({
    dedicated = optional(number, 2048)
    floating  = optional(number)
    shared    = optional(number)
  })
  description = "The Memory Configuration of the VM."
  default     = {}
}

variable "vm_display" {
  type = object({
    type   = optional(string, "std")
    memory = optional(number, 16)
  })
  description = "The Display Configuration of the VM."
  default     = {}

  validation {
    condition     = contains(["none", "cirrus", "qxl", "qxl2", "qxl3", "qxl4", "serial0", "serial1", "serial2", "serial3", "std", "virtio", "virtio-gl", "vmware"], var.vm_display.type)
    error_message = "Valid values for var: vm_display.type are (none, cirrus, qxl, qxl2, qxl3, qxl4, serial0, serial1, serial2, serial3, std, virtio, virtio-gl, vmware)."
  }
}

variable "vm_pcie" {
  type = map(object({
    name        = string
    pcie        = optional(bool, true)
    primary_gpu = optional(bool, false)
  }))
  description = "VM host PCI device mapping."
  nullable    = true
  default     = null
}

variable "vm_efi_disk" {
  type = object({
    datastore_id      = string
    file_format       = optional(string, "raw")
    type              = optional(string, "4m")
    pre_enrolled_keys = optional(bool, false)
  })
  description = "The UEFI disk device."
  nullable    = true
  default     = null
}

variable "vm_disk" {
  type = map(object({
    datastore_id = string
    size         = number
    file_format  = optional(string, "raw")
    iothread     = optional(bool, true)
    main_disk    = optional(bool, false)
  }))
  description = "VM Disks configuration. Use the 'main_disk' value to tag a disk as main to host the VM image. Only usefull with creation type 'image'."

  validation {
    condition     = alltrue([for k, v in var.vm_disk : can(regex("(?:scsi|sata|virtio)\\d+", k))])
    error_message = "The IDs (keys) of the hard disk must respect the following convention: scsi[id], sata[id], virtio[id]."
  }

  validation {
    condition     = length([for k, v in var.vm_disk : k if v.main_disk]) <= 1
    error_message = "Only one disk at maximum can be tagged as main to host the VM image."
  }
}

variable "vm_net_ifaces" {
  type = map(object({
    bridge     = string
    enabled    = optional(bool, true)
    firewall   = optional(bool, true)
    mac_addr   = optional(string)
    model      = optional(string, "virtio")
    mtu        = optional(number, 1500)
    rate_limit = optional(string)
    vlan_id    = optional(number)
    ipv4_addr  = string
    ipv4_gw    = string
  }))
  description = "VM network interfaces configuration. Terraform provider bpg/proxmox cannot work properly without network access."

  validation {
    condition     = alltrue([for k, v in var.vm_net_ifaces : can(regex("net\\d+", k))])
    error_message = "The IDs (keys) of the network device must respect the following convention: net[id]."
  }
}

variable "vm_init" {
  type = object({
    datastore_id = string
    interface    = optional(string, "ide0")
    user = optional(object({
      name     = optional(string)
      password = optional(string)
      keys     = optional(list(string))
    }))
    dns = optional(object({
      domain  = optional(string)
      servers = optional(list(string))
    }))
  })
  description = "Initial configuration for the VM. Required for the creation of the Cloud-Init drive."

  validation {
    condition     = can(regex("(?:scsi|sata|ide)\\d+", var.vm_init.interface))
    error_message = "The IDs (keys) of the CloudInit drive must respect the following convention: scsi[id], sata[id], ide[id]."
  }
}

variable "vm_user_data" {
  type        = string
  description = "cloud-init configuration for the VM's users."
  nullable    = true
  default     = null
}

# =============================================================================
# ===== Host Firewall =========================================================
# =============================================================================

variable "vm_fw_opts" {
  type = object({
    enabled       = bool
    dhcp          = optional(bool)
    input_policy  = optional(string)
    output_policy = optional(string)
    macfilter     = optional(bool)
    ipfilter      = optional(bool)
    ndp           = optional(bool)
    radv          = optional(bool)
  })
  description = "Firewall settings for the VM."
  nullable    = true
  default     = null
}

variable "vm_fw_rules" {
  type = map(object({
    enabled   = optional(bool, true)
    action    = string
    direction = string
    iface     = optional(string)
    proto     = optional(string)
    srcip     = optional(string)
    srcport   = optional(string)
    destip    = optional(string)
    destport  = optional(string)
    comment   = optional(string)
  }))
  description = "Firewall rules for the VM."
  nullable    = true
  default     = null
}


variable "vm_fw_group" {
  type = map(object({
    enabled = optional(bool, true)
    iface   = optional(string)
    comment = optional(string)
  }))
  description = "Firewall Security Groups for the VM."
  nullable    = true
  default     = null
}
