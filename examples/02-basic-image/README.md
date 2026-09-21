# Example 02: Basic Image

The 02-basic-image example uses the terraform-bgp-proxmox-vm module to deploy a single Virtual Machine to a proxmox server using an ISO or raw disk as base.

## Inputs

Here are the input variables of the example:

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- |---------|:--------:|
| <a name="variable_proxmox_host"></a> [proxmox\_host](#variable\_proxmox\_host) | Proxmox API Host. has to be in the form IP:PORT. | `string` | `n/a` | **yes** |
| <a name="variable_proxmox_node"></a> [proxmox\_node](#variable\_proxmox\_node) | Proxmox node on which the virtual machine will be created. | `string` | `n/a` | **yes** |
| <a name="variable_proxmox_api_token_id"></a> [proxmox\_api\_token\_id](#variable\_proxmox\_api\_token\_id) | Proxmox API Token ID. | `string` | `n/a` | **yes** |
| <a name="variable_proxmox_api_token_secret"></a> [proxmox\_api\_token\_secret](#variable\_proxmox\_api\_token\_secret) | Proxmox API Token Secret. | `string` | `n/a` | **yes** |
| <a name="variable_proxmox_ssh_private_key"></a> [proxmox\_ssh\_private\_key](#variable\_proxmox\_ssh\_private\_key) | The SSH private key to use when connecting via SSH to the Proxmox node. | `string` | `n/a` | **yes** |

## Outputs

  Here are the outputs of the example:

| Name | Description |
|------|-------------|
| <a name="output_module"></a> [module](#output\_module) | Module Output. |
