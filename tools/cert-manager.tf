resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = "1.11.0"
  namespace        = "cert-manager"
  reuse_values     = true
  cleanup_on_fail  = true
  create_namespace = true
  values = [
    "${file("${path.module}/manifests/cert-manager/cert-manager.yaml")}"
  ]
}

## apply the config below and its dependencies first, not tls-jx-apps-eks-dev-okd-bicloud-igt-com-p

resource "kubernetes_manifest" "cert_manager_prod_clusterissuer" {
  depends_on = [
    helm_release.cert_manager
  ]
  manifest = yamldecode(file("${path.module}/manifests/cert-manager/cert-manager-prod-clusterissuer.yaml"))
}

resource "kubernetes_manifest" "cert_manager_prod_certificate" {
  depends_on = [
    kubernetes_manifest.cert_manager_prod_clusterissuer
  ]
  manifest = yamldecode(file("${path.module}/manifests/cert-manager/cert-manager-prod-certificate.yaml"))
}