# get (externally configured) DNS Zone
data "aws_route53_zone" "base_domain" {
  name = var.dns_base_domain
}

# create AWS-issued SSL certificate
# this must be manually approved if stuck
resource "aws_acm_certificate" "cheguei_domain_cert" {
  domain_name               = var.dns_base_domain
  subject_alternative_names = ["*.${var.dns_base_domain}"]
  validation_method         = "DNS"
}

# Validate certs
resource "aws_route53_record" "certs" {
  for_each = {
    for dvo in aws_acm_certificate.cheguei_domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.base_domain.zone_id
}

## createa a subodmain containers.cheguei.app to containers_cheguei ec2 instance
resource "aws_route53_record" "deployments_subdomains" {
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.base_domain.id
  name            = "swarm.cheguei.app"
  type            = "A"

  alias {
    name                   = aws_alb.swarm_cheguei_lb.dns_name
    zone_id                = aws_alb.swarm_cheguei_lb.zone_id
    evaluate_target_health = false
  }
}

## createa a subodmain containers.cheguei.app to containers_cheguei ec2 instance
resource "aws_route53_record" "deployments_subdomains_metrics" {
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.base_domain.id
  name            = "swarmpit.cheguei.app"
  type            = "A"

  alias {
    name                   = aws_alb.swarm_cheguei_lb.dns_name
    zone_id                = aws_alb.swarm_cheguei_lb.zone_id
    evaluate_target_health = false
  }
}


# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "swarm_cert" {
  certificate_arn         = aws_acm_certificate.cheguei_domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.certs : record.fqdn]
}
