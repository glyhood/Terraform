resource "helm_release" "kubernetes_dashboard" {
  name             = "kubernetes-dashboard"
  chart            = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  namespace        = "kubernetes-dashboard"
  reuse_values     = true
  cleanup_on_fail  = true
  create_namespace = true
  values = [
    "${file("${path.module}/manifests/k8-dashboard/k8-dashboard.yaml")}"
  ]
}

resource "kubernetes_manifest" "kubernetes_dashboard_crb" {
  depends_on = [
    helm_release.kubernetes_dashboard
  ]
  manifest = yamldecode(file("${path.module}/manifests/k8-dashboard/k8-dashboard-crb.yaml"))
}