resource "cloudflare_ruleset" "redirects" {
  depends_on = [cloudflare_dns_record.this]
  for_each   = { for k, v in var.records : k => v if v.redirect != null }

  zone_id = var.zone_id
  name    = format("%s: %s (Redirect)", each.value.project, each.key)
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules = [{
    enabled     = true
    description = format("Redirect %s.%s to %s", each.value.subdomain, var.domain, each.value.redirect)
    expression  = format("(http.host eq \"%s.%s\")", each.value.subdomain, var.domain)
    action      = "redirect"

    action_parameters = {
      from_value = {
        status_code           = 301
        target_url            = { value = each.value.redirect }
        preserve_query_string = true
      }
    }
  }]

  lifecycle {
    precondition {
      condition     = each.value.redirect && each.value.proxied
      error_message = format("Redirect \"%s\" requires proxying", each.value.redirect)
    }
  }
}

