resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  chart            = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  version          = "3.8.3"
  namespace        = "kube-system"
  reuse_values     = true
  cleanup_on_fail  = true
  create_namespace = true
}
