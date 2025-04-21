locals {
  env = var.env == "prod" ? "" : "${var.env}."
}

data "aws_route53_zone" "scrubs_domain" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_record" "scrubs_api" {
  zone_id = data.aws_route53_zone.scrubs_domain.zone_id
  name    = "${local.env}api.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [var.domain]

}

resource "aws_route53_record" "scrubs_web" {
  zone_id = data.aws_route53_zone.scrubs_domain.zone_id
  name    = "www.${local.env}${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [var.domain]
}

resource "aws_route53_record" "scrubs_k8s_api" {
  count = var.env == "prod" ? 0 : 1
  zone_id = data.aws_route53_zone.scrubs_domain.zone_id
  name    = "k8s.api.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [var.domain]
}