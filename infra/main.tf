module "dns" {
  source = "./localmodules/dns"
  domain = "shukomango.co.in" # This domain must be registered in Route53 with an apex A record point to cluster
  env    = var.env
}

module "k8s-oidc" {
  count = var.env == "prod" ? 0 : 1
  source = "./localmodules/k8s-oidc"
  k8s_api_domain_name = module.dns.k8s_api_domain_name
}