resource "helm_release" "replicator" {
  name             = "replicator"
  chart            = "kubernetes-replicator"
  repository       = "https://helm.mittwald.de"
  version          = "2.7.3"
  namespace        = "replicator"
  reuse_values     = true
  cleanup_on_fail  = true
  create_namespace = true
}
