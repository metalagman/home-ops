data "kubectl_kustomize_documents" "nginx_gateway_fabric_crds" {
  # Pin CRDs to a known NGF release tag.
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
