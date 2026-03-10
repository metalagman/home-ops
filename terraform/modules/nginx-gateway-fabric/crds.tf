data "kubectl_kustomize_documents" "nginx_gateway_fabric_crds" {
  # Upstream CRDs are in config/crd/bases at the tagged version; config/crd
  # kustomization aggregates all base CRDs, so we target it directly.
  target = "https://github.com/nginx/nginx-gateway-fabric/config/crd?ref=${var.crd_version}"
}

resource "kubectl_manifest" "nginx_gateway_fabric_crds" {
  for_each = {
    for idx, doc in data.kubectl_kustomize_documents.nginx_gateway_fabric_crds.documents :
    tostring(idx) => doc
  }

  yaml_body = each.value

  server_side_apply = true
  force_conflicts   = true
  wait_for_rollout  = false
}
