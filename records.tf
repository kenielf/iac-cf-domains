resource "cloudflare_dns_record" "this" {
  for_each = var.records

  zone_id = var.zone_id
  name    = each.value.subdomain
  ttl     = coalesce(each.value.ttl, var.default_ttl)
  type    = each.value.type
  comment = format("%s", each.key)
  content = each.value.content
  proxied = each.value.proxied
}

