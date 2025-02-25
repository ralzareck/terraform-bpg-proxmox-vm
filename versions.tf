# =============================================================================
# ===== Provider ==============================================================
# =============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    proxmox = {
      version = ">= 0.66"
      source  = "bpg/proxmox"
    }
  }
}
