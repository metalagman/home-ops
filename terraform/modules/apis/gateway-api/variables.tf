variable "release_version" {
  description = "Gateway API release tag."
  type        = string
  default     = "v1.4.1"

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.release_version))
    error_message = "release_version must be a semantic release tag such as v1.4.1."
  }
}

variable "channel" {
  description = "Gateway API installation channel."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "experimental"], var.channel)
    error_message = "channel must be standard or experimental."
  }
}

variable "force_conflicts" {
  description = "Whether server-side apply may take ownership of conflicting fields."
  type        = bool
  default     = false
}
