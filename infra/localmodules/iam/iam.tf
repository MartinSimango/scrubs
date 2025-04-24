# resource "aws_iam_role" "oidc_role" {
#   name = "oidc-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Federated = aws_iam_openid_connect_provider.k8s_oidc.arn
#         }
#         Condition = {
#           StringEquals = {
#             "${var.k8s_api_domain_name}:aud" : "sts.amazonaws.com"
#           }
# Add another condition to check sub i.e ${var.k8s_api_domain_name}:sub
#         }
#       },
#     ]
#   })
# }
#

# TODO OIDC policies will be added here

resource "aws_iam_user" "kubernetes" {
  name = "kubernetes"
}

resource "aws_iam_role" "dns_updater" {
  name = "dns-updater"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AllowKubernetesToAssumeDNSUpdaterRole"
        Principal = {
          AWS = aws_iam_user.kubernetes.arn
        }
      }
    ]
  })
}


resource "aws_iam_policy" "dns_updater" {
  name        = "dns-updater-policy"
  description = "Allow updating records in Route53"
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

resource "aws_iam_role_policy_attachment" "dns_updater" {
  role       = aws_iam_role.dns_updater.name
  policy_arn = aws_iam_policy.dns_updater.arn
}
