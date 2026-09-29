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
# ===== Variables =============================================================
# =============================================================================

variable "proxmox_host" {
  description = "Proxmox API Host. Has to be in the form IP:PORT."
  type        = string
}

variable "proxmox_node" {
  description = "Proxmox node on which the virtual machine will be created."
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API Token ID."
  sensitive   = true
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API Token Secret."
  sensitive   = true
  type        = string
}

variable "proxmox_ssh_private_key" {
  description = "The SSH private key to use when connecting via SSH to the Proxmox node."
  sensitive   = true
  type        = string
}
