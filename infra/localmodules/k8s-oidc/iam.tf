data "tls_certificate" "k8s_oidc" {
  url          = "https://${var.k8s_api_domain_name}"
  verify_chain = false
}
resource "aws_iam_openid_connect_provider" "k8s_oidc" {
  url             = "https://${var.k8s_api_domain_name}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["${data.tls_certificate.k8s_oidc.certificates.0.sha1_fingerprint}"]
}


resource "aws_iam_policy" "dns_updater" {
  name        = "dns-updater-policy"
  description = "Allow updating A records in Route53"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]
        Resource = ["*"]
      }
    ]
  })
}


resource "aws_iam_role" "dns_updater" {
  name = "dns-updater"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = aws_iam_openid_connect_provider.k8s_oidc.arn
        }
        Condition = {
          StringEquals = {
            "${var.k8s_api_domain_name}:aud" : "sts.amazonaws.com"
          }
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "dns_updater" {
  role       = aws_iam_role.dns_updater.name
  policy_arn = aws_iam_policy.dns_updater.arn
}
