resource "kubernetes_namespace_v1" "openebs" {
  metadata {
    name = "openebs"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "helm_release" "openebs" {
  name             = "openebs"
  repository       = "https://openebs.github.io/openebs"
  chart            = "openebs"
  version          = "4.4.0"
  namespace        = kubernetes_namespace_v1.openebs.metadata[0].name
  create_namespace = false
  cleanup_on_fail  = true
  upgrade_install  = true
  wait             = true
  atomic           = true
  timeout          = 600

  values = [<<-YAML
openebs-crds:
  csi:
    volumeSnapshots:
      enabled: true
      keep: true

# 1-node: HostPath only
engines:
  local:
    lvm:
      enabled: true
    zfs:
      enabled: false
    rawfile:
      enabled: false
  replicated:
    mayastor:
      enabled: false

# Dynamic LocalPV Provisioner (HostPath)
localpv-provisioner:
  rbac:
    create: true
  hostpathClass:
    enabled: true
    isDefaultClass: true
    basePath: /var/openebs/local
  deviceClass:
    enabled: false
  # If your single node is also control-plane, uncomment:
  tolerations:
    - key: node-role.kubernetes.io/control-plane
      operator: Exists
      effect: NoSchedule
    - key: node-role.kubernetes.io/master
      operator: Exists
      effect: NoSchedule

# 1-node: disable bundled logging stack (enabled by default in 4.4)
loki:
  enabled: false
alloy:
  enabled: false

# Fresh install: disable v3->v4 pre-upgrade hook
preUpgradeHook:
  enabled: false
YAML
  ]
}

resource "kubectl_manifest" "openebs_hdd_lvm_storage_class" {
  depends_on = [helm_release.openebs]

  yaml_body = <<-YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: openebs-hdd-lvm
provisioner: local.csi.openebs.io
allowVolumeExpansion: true
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
parameters:
  storage: "lvm"
  volgroup: "openebs-hdd-vg"
  fsType: "ext4"
YAML

  server_side_apply = true
  force_conflicts   = true
}
