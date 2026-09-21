<!-- markdownlint-disable MD033 -->
# terraform-bpg-proxmox-vm

Based on [bpg's provider](https://github.com/bpg/terraform-provider-proxmox)

## Create a QEMU VM on ProxmoxVE using Terraform

This module deploys a QEMU Virtual Machine on ProxmoxVE host, with firewall configuration.
It can be based on an already deployed VM template, or an existing disk image.

![GitHub License](https://img.shields.io/github/license/ralzareck/terraform-module-bgp-pve-vm?style=flat&color=blue)

## Providers

Here is the list of required providers:

| Name                                                               | Version   |
| ------------------------------------------------------------------ | --------- |
| [bgp/proxmox](https://registry.terraform.io/providers/bpg/proxmox) | >= 0.66.0 |

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_firewall_options.pve_vm_fw_opts](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_options) | resource |
| [proxmox_virtual_environment_firewall_rules.pve_vm_fw_rules](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_rules) | resource |
| [proxmox_virtual_environment_vm.pve_vm](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |

## Inputs

Here are the input variables of the module:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pve_node"></a> [pve\_node](#input\_pve\_node) | PVE Node name on which the VM will be created on. | `string` | `n/a` | **yes** |
| <a name="input_vm_type"></a> [vm\_type](#input\_vm\_type) | The source type used for the creation of the container. Can either be 'clone' or 'image'. | `string` | `n/a` | **yes** |
| <a name="input_src_clone"></a> [src\_clone](#input\_src\_clone) | The target to clone as base for the VM. Cannot be used with 'src\_file' | <pre>object({<br/>    datastore\_id = string<br/>    node\_name    = optional(string)<br/>    tpl\_id       = number<br/>  })</pre> | `null` | **no** |
| <a name="input_src_file"></a> [src\_file](#input\_src\_file) | The target ISO file to use as base for the VM. Cannot be used with 'src\_clone' | <pre>object({<br/>    datastore\_id = string<br/>    file\_name    = string<br/>  })</pre> | `null` | **no** |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the VM. | `string` | `n/a` | **yes** |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | The ID of the VM. | `number` | `null` | **no** |
| <a name="input_vm_description"></a> [vm\_description](#input\_vm\_description) | The description of the VM. | `string` | `null` | **no** |
| <a name="input_vm_pool"></a> [vm\_pool](#input\_vm\_pool) | The Pool in which to place the VM. | `string` | `null` | **no** |
| <a name="input_vm_tags"></a> [vm\_tags](#input\_vm\_tags) | A list of tags associated to the VM. | `list(string)` | `[]` | **no** |
| <a name="input_vm_start"></a> [vm\_start](#input\_vm\_start) | The start settings for the VM. | <pre>object({<br/>    on\_deploy  = bool<br/>    on\_boot    = bool<br/>    order      = optional(number, 0)<br/>    up\_delay   = optional(number, 0)<br/>    down\_delay = optional(number, 0)<br/>  })</pre> | <pre>{<br/>  "down\_delay": 0,<br/>  "on\_boot": true,<br/>  "on\_deploy": true,<br/>  "order": 0,<br/>  "up\_delay": 0<br/>}</pre> | **no** |
| <a name="input_vm_bios"></a> [vm\_bios](#input\_vm\_bios) | The BIOS Implementation of the VM. Can either be 'seabios' or 'ovmf'. | `string` | `"seabios"` | **no** |
| <a name="input_vm_machine"></a> [vm\_machine](#input\_vm\_machine) | The machine type of the VM. | `string` | `"q35"` | **no** |
| <a name="input_vm_scsi_hardware"></a> [vm\_scsi\_hardware](#input\_vm\_scsi\_hardware) | The SCSI hardware type of the VM. | `string` | `"virtio-scsi-single"` | **no** |
| <a name="input_vm_os"></a> [vm\_os](#input\_vm\_os) | The Operating System configuration of the VM. | `string` | `"l26"` | **no** |
| <a name="input_vm_cpu"></a> [vm\_cpu](#input\_vm\_cpu) | The CPU Configuration of the VM. | <pre>object({<br/>    type  = optional(string, "host")<br/>    cores = optional(number, 2)<br/>    units = optional(number)<br/>  })</pre> | `{}` | **no** |
| <a name="input_vm_mem"></a> [vm\_mem](#input\_vm\_mem) | The Memory Configuration of the VM. | <pre>object({<br/>    dedicated = optional(number, 2048)<br/>    floating  = optional(number)<br/>    shared    = optional(number)<br/>  })</pre> | `{}` | **no** |
| <a name="input_vm_display"></a> [vm\_display](#input\_vm\_display) | The Display Configuration of the VM. | <pre>object({<br/>    type   = optional(string, "std")<br/>    memory = optional(number, 16)<br/>  })</pre> | `{}` | **no** |
| <a name="input_vm_pcie"></a> [vm\_pcie](#input\_vm\_pcie) | VM host PCI device mapping. | <pre>map(object({<br/>    name        = string<br/>    pcie        = optional(bool, true)<br/>    primary\_gpu = optional(bool, false)<br/>  }))</pre> | `null` | **no** |
| <a name="input_vm_efi_disk"></a> [vm\_efi\_disk](#input\_vm\_efi\_disk) | The UEFI disk device. | <pre>object({<br/>    datastore\_id      = string<br/>    file\_format       = optional(string, "raw")<br/>    type              = optional(string, "4m")<br/>    pre\_enrolled\_keys = optional(bool, false)<br/>  })</pre> | `null` | **no** |
| <a name="input_vm_disk"></a> [vm\_disk](#input\_vm\_disk) | VM Disks configuration. Use the 'main\_disk' value to tag a disk as main to host the VM image. Only usefull with creation type 'image'. | <pre>map(object({<br/>    datastore\_id = string<br/>    size         = number<br/>    file\_format  = optional(string, "raw")<br/>    iothread     = optional(bool, true)<br/>    main\_disk    = optional(bool, false)<br/>  }))</pre> | `n/a` | **yes** |
| <a name="input_vm_net_ifaces"></a> [vm\_net\_ifaces](#input\_vm\_net\_ifaces) | VM network interfaces configuration. Terraform provider bpg/proxmox cannot work properly without network access. | <pre>map(object({<br/>    bridge     = string<br/>    enabled    = optional(bool, true)<br/>    firewall   = optional(bool, true)<br/>    mac\_addr   = optional(string)<br/>    model      = optional(string, "virtio")<br/>    mtu        = optional(number, 1500)<br/>    rate\_limit = optional(string)<br/>    vlan\_id    = optional(number)<br/>    ipv4\_addr  = string<br/>    ipv4\_gw    = string<br/>  }))</pre> | `n/a` | **yes** |
| <a name="input_vm_init"></a> [vm\_init](#input\_vm\_init) | Initial configuration for the VM. Required for the creation of the Cloud-Init drive. | <pre>object({<br/>    datastore\_id = string<br/>    interface    = optional(string, "ide0")<br/>    user = optional(object({<br/>      name     = optional(string)<br/>      password = optional(string)<br/>      keys     = optional(list(string))<br/>    }))<br/>    dns = optional(object({<br/>      domain  = optional(string)<br/>      servers = optional(list(string))<br/>    }))<br/>  })</pre> | `n/a` | **yes** |
| <a name="input_vm_user_data"></a> [vm\_user\_data](#input\_vm\_user\_data) | cloud-init configuration for the VM's users | `string` | `null` | **no** |
| <a name="input_vm_fw_opts"></a> [vm\_fw\_opts](#input\_vm\_fw\_opts) | Firewall settings for the VM. | <pre>object({<br/>    enabled       = bool<br/>    dhcp          = optional(bool)<br/>    input\_policy  = optional(string)<br/>    output\_policy = optional(string)<br/>    macfilter     = optional(bool)<br/>    ipfilter      = optional(bool)<br/>    ndp           = optional(bool)<br/>    radv          = optional(bool)<br/>  })</pre> | `null` | **no** |
| <a name="input_vm_fw_rules"></a> [vm\_fw\_rules](#input\_vm\_fw\_rules) | Firewall rules for the VM. | <pre>map(object({<br/>    enabled   = optional(bool, true)<br/>    action    = string<br/>    direction = string<br/>    iface     = optional(string)<br/>    proto     = optional(string)<br/>    srcip     = optional(string)<br/>    srcport   = optional(string)<br/>    destip    = optional(string)<br/>    destport  = optional(string)<br/>    comment   = optional(string)<br/>  }))</pre> | `null` | **no** |
| <a name="input_vm_fw_group"></a> [vm\_fw\_group](#input\_vm\_fw\_group) | Firewall Security Groups for the VM. | <pre>map(object({<br/>    enabled = optional(bool, true)<br/>    iface   = optional(string)<br/>    comment = optional(string)<br/>  }))</pre> | `null` | **no** |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pve_node"></a> [pve\_node](#output\_pve\_node) | Name of the Proxmox Node |
| <a name="output_pve_id"></a> [pve\_id](#output\_pve\_id) | Proxmox ID of the instance |
| <a name="output_pve_pool"></a> [pve\_pool](#output\_pve\_pool) | Proxmox Pool of the instance |
| <a name="output_pve_type"></a> [pve\_type](#output\_pve\_type) | Proxmox type of virtualization |
| <a name="output_name"></a> [name](#output\_name) | Name of the instance |
| <a name="output_cpu"></a> [cpu](#output\_cpu) | Number of CPU of the instance |
| <a name="output_mem"></a> [mem](#output\_mem) | Memory size of the instance |
| <a name="output_bios"></a> [bios](#output\_bios) | BIOS of the instance |
| <a name="output_disk"></a> [disk](#output\_disk) | Disk information of the instance |
| <a name="output_efi_disk"></a> [efi\_disk](#output\_efi\_disk) | EFI Disk information of the instance |
| <a name="output_iface"></a> [iface](#output\_iface) | List of Iface of the instance |
| <a name="output_ip"></a> [ip](#output\_ip) | Couple Iface / IP of the instance |
<!-- END_TF_DOCS -->
