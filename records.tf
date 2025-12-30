resource "cloudflare_dns_record" "this" {
  for_each = var.records

  zone_id = var.zone_id
  name    = each.value.subdomain
  ttl     = coalesce(each.value.ttl, var.default_ttl)
  type    = each.value.type
  comment = format("%s: %s", each.value.project, each.key)
  content = coalesce(each.value.content, var.internal_dns)
  proxied = each.value.proxied

  lifecycle {
    precondition {
      condition     = length(each.key) > 3
      error_message = "Record name is too small, minimum is 3."
    }
  }
}

