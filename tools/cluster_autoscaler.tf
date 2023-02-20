resource "helm_release" "cluster_autoscaler" {
  name             = "cluster-autoscaler"
  chart            = "cluster-autoscaler"
  repository       = "https://kubernetes.github.io/autoscaler"
  version          = "9.23.0"
  namespace        = "kube-system"
  reuse_values     = true
  cleanup_on_fail  = true
  create_namespace = true
  values = [
    templatefile(
      "${path.module}/manifests/cluster-autoscaler.yaml",
      {
        clusterName = "${var.cluster_name}"
      }
    )
  ]
}
