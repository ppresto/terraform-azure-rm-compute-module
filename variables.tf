variable "location" {
  description = "Azure location in which to create resources"
  default     = "East US"
}

variable "count_windows" {
  description = "Azure location in which to create resources"
  default     = 0
}

variable "count_linux" {
  description = "Azure location in which to create resources"
  default     = 2
}

variable "dns_prefix" {
  description = "DNS prefix to add to to public IP address for Windows VM"
  default     = "ppresto"
}
