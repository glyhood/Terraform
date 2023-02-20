resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  chart            = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  version          = "0.7.2"
  namespace        = "external-secrets"
  reuse_values     = true
  cleanup_on_fail  = true
  create_namespace = true
  values = [
    "${file("${path.module}/manifests/external-secrets/external_secrets.yaml")}"
  ]
}

resource "kubernetes_manifest" "external_secrets_clustersecretstore" {
  depends_on = [
    helm_release.external_secrets
  ]
  manifest = yamldecode(file("${path.module}/manifests/external-secrets/external_secrets_clustersecretstore.yaml"))
}

resource "kubernetes_manifest" "route53_secret" {
  depends_on = [
    helm_release.external_secrets
  ]
  manifest = yamldecode(file("${path.module}/manifests/external-secrets/route53-secret.yaml"))
}
