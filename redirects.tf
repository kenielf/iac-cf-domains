resource "cloudflare_ruleset" "redirects" {
  depends_on = [ cloudflare_dns_record.this ]
  for_each = { for k, v in var.records: k => v if v.redirect != null }

  zone_id = var.zone_id
  name    = format("%s: %s (Redirect)", each.value.project, each.key)
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules {
    description = format("Redirect %s.%s to %s", each.value.subdomain, var.domain, each.value.redirect)
    enabled     = true

    expression = <<-EOF
      (http.host eq "${each.value.subdomain}.${var.domain}")
    EOF

    action = "redirect"

    action_parameters {
      from_value {
        status_code = 301
        target_url {
          value = each.value.redirect
        }
        preserve_query_string = true
      }
    }
  }
}

