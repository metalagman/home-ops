variable "argocd_chart_version" {
  description = "Helm chart version for Argo CD."
  type        = string
  default     = "9.3.4"
}

variable "argocd_app_version" {
  description = "Argo CD app version tag or commit (pin to a tag/commit, not master)."
  type        = string
  default     = "v3.2.5"
}
