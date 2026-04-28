terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

locals {
  clickhouse_service_selector = length(var.clickhouse_service_selector) > 0 ? var.clickhouse_service_selector : {
    "app" = "${var.clickhouse_cluster_name}-clickhouse"
  }
}

resource "kubernetes_namespace_v1" "clickhouse" {
  metadata {
    name = var.clickhouse_namespace
  }
}

resource "kubernetes_secret_v1" "clickhouse_s3_credentials" {
  metadata {
    name      = var.clickhouse_s3_credentials_secret_name
    namespace = kubernetes_namespace_v1.clickhouse.metadata[0].name
  }

  data = {
    access_key_id     = var.clickhouse_s3_access_key_id
    secret_access_key = var.clickhouse_s3_secret_access_key
  }

  type = "Opaque"
}

resource "kubectl_manifest" "keeper_cluster" {
  yaml_body = <<YAML
apiVersion: "clickhouse.com/v1alpha1"
kind: "KeeperCluster"
metadata:
  name: "${var.keeper_cluster_name}"
  namespace: "${kubernetes_namespace_v1.clickhouse.metadata[0].name}"
spec:
  replicas: ${var.keeper_replicas}
  dataVolumeClaimSpec:
    storageClassName: "${var.clickhouse_storage_class_name}"
    resources:
      requests:
        storage: "${var.keeper_storage_size}"
YAML

  depends_on = [kubernetes_namespace_v1.clickhouse]
}

resource "kubectl_manifest" "clickhouse_cluster" {
  yaml_body = <<YAML
apiVersion: "clickhouse.com/v1alpha1"
kind: "ClickHouseCluster"
metadata:
  name: "${var.clickhouse_cluster_name}"
  namespace: "${kubernetes_namespace_v1.clickhouse.metadata[0].name}"
spec:
  replicas: ${var.clickhouse_replicas}
  shards: ${var.clickhouse_shards}
  containerTemplate:
    env:
      - name: CLICKHOUSE_S3_ACCESS_KEY_ID
        valueFrom:
          secretKeyRef:
            name: "${kubernetes_secret_v1.clickhouse_s3_credentials.metadata[0].name}"
            key: access_key_id
      - name: CLICKHOUSE_S3_SECRET_ACCESS_KEY
        valueFrom:
          secretKeyRef:
            name: "${kubernetes_secret_v1.clickhouse_s3_credentials.metadata[0].name}"
            key: secret_access_key
  keeperClusterRef:
    name: "${var.keeper_cluster_name}"
  dataVolumeClaimSpec:
    storageClassName: "${var.clickhouse_storage_class_name}"
    resources:
      requests:
        storage: "${var.clickhouse_storage_size}"
  settings:
    extraConfig:
      storage_configuration:
        disks:
          object_storage:
            type: s3
            endpoint: "${var.clickhouse_s3_endpoint}"
            access_key_id:
              "@from_env": CLICKHOUSE_S3_ACCESS_KEY_ID
            secret_access_key:
              "@from_env": CLICKHOUSE_S3_SECRET_ACCESS_KEY
            path: "/var/lib/clickhouse/disks/object_storage/"
            metadata_path: "/var/lib/clickhouse/disks/object_storage/"
          object_storage_cache:
            type: cache
            disk: object_storage
            path: "/var/lib/clickhouse/disks/object_storage_cache/"
            max_size: "${var.clickhouse_s3_cache_max_size}"
        policies:
          default:
            move_factor: 0.01
            volumes:
              default:
                disk: default
              object_storage:
                disk: object_storage
                prefer_not_to_merge: 1
          local:
            move_factor: 0
            volumes:
              default:
                disk: default
          object_storage:
            move_factor: 0
            volumes:
              object_storage:
                disk: object_storage
                prefer_not_to_merge: 1
YAML

  depends_on = [
    kubernetes_namespace_v1.clickhouse,
    kubernetes_secret_v1.clickhouse_s3_credentials,
    kubectl_manifest.keeper_cluster,
  ]
}

resource "kubernetes_service_v1" "clickhouse_lb" {
  metadata {
    name        = var.clickhouse_service_name
    namespace   = kubernetes_namespace_v1.clickhouse.metadata[0].name
    annotations = var.clickhouse_service_annotations
  }

  spec {
    type                    = "LoadBalancer"
    selector                = local.clickhouse_service_selector
    load_balancer_class     = var.clickhouse_service_load_balancer_class
    load_balancer_ip        = var.clickhouse_service_load_balancer_ip
    external_traffic_policy = var.clickhouse_service_external_traffic_policy

    port {
      name        = "native"
      port        = var.clickhouse_service_native_port
      target_port = var.clickhouse_service_native_port
      protocol    = "TCP"
    }

    port {
      name        = "http"
      port        = var.clickhouse_service_http_port
      target_port = var.clickhouse_service_http_port
      protocol    = "TCP"
    }
  }

  depends_on = [kubectl_manifest.clickhouse_cluster]
}
