variable "domain" {
  type = string
  nullable = false
}

variable "zone_id" {
  type = string
  nullable = false
}

variable "records" {
  type = map(object({
    project   = string,
    subdomain = string,
    ttl       = optional(number),
    type      = string
    content   = string,
    proxied   = optional(bool, false),
    redirect  = optional(string)
  }))
  nullable = false
}

variable "default_ttl" {
  type    = number
  default = 1
  nullable = false
}
