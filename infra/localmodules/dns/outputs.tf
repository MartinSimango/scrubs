output "k8s_api_domain_name" {
  value = try(aws_route53_record.scrubs_k8s_api[0].fqdn,"")
}