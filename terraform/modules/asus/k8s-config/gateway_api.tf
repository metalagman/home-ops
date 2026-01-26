variable "gateway_api_version" {
  type    = string
  default = "v1.4.1"
}

locals {
  gateway_api_url = "https://github.com/kubernetes-sigs/gateway-api/releases/download/${var.gateway_api_version}/standard-install.yaml"
}

# 1) Download the release bundle (same thing as kubectl apply -f URL)
data "http" "gateway_api" {
  url = local.gateway_api_url
}

# 2) Split multi-doc YAML into individual manifests
data "kubectl_file_documents" "gateway_api" {
  content = data.http.gateway_api.response_body
}

# 3) Apply every document
resource "kubectl_manifest" "gateway_api" {
  for_each  = data.kubectl_file_documents.gateway_api.manifests
  yaml_body = each.value

  # Equivalent intent to: kubectl apply --server-side ...
  server_side_apply = true
}
