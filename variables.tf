variable "location" {
  description = "Azure location in which to create resources"
  default     = "East US"
}

variable "count" {
  description = "Azure location in which to create resources"
  default     = 1
}

variable "dns_prefix" {
  description = "DNS prefix to add to to public IP address for Windows VM"
  default     = "ppresto"
}
