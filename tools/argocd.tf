resource "helm_release" "argocd" {
  name             = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "5.17.4"
  namespace        = "argocd"
  reuse_values     = true
  cleanup_on_fail  = true
  create_namespace = true
  values = [
    templatefile(
      "${path.module}/manifests/argocd.yaml",
      {
        argocd_bitbucket_token = jsondecode(data.aws_secretsmanager_secret_version.argocd_bitbucket_token.secret_string)["argocd_bitbucket_token"]
      }
    )
  ]
}

data "aws_secretsmanager_secret" "argocd_bitbucket_token" {
  name = "argocd_bitbucket_token"
}

data "aws_secretsmanager_secret_version" "argocd_bitbucket_token" {
  secret_id = data.aws_secretsmanager_secret.argocd_bitbucket_token.id
}