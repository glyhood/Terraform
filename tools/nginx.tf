resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  version          = "4.4.2"
  namespace        = "nginx"
  reuse_values     = true
  cleanup_on_fail  = true
  create_namespace = true
  values = [
    "${file("${path.module}/manifests/nginx.yaml")}"
  ]
}
