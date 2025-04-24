data "tls_certificate" "k8s_oidc" {
  url          = "https://${var.k8s_api_domain_name}"
  verify_chain = false
}
resource "aws_iam_openid_connect_provider" "k8s_oidc" {
  url             = "https://${var.k8s_api_domain_name}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["${data.tls_certificate.k8s_oidc.certificates.0.sha1_fingerprint}"]
}

