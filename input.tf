variable "zone_id" {
  type = string
}

variable "records" {
  type = map(object({
    subdomain = string,
    ttl       = optional(number),
    type      = string
    content   = string,
    proxied   = optional(bool, false)
  }))
}

variable "default_ttl" {
  type    = number
  default = 1
}
