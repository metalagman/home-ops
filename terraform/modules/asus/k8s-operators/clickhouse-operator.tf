module "clickhouse_operator" {
  source = "github.com/metalagman/home-ops//terraform/modules/clickhouse-operator?ref=master"

  clickhouse_operator_chart_version = var.clickhouse_operator_chart_version
  clickhouse_operator_namespace     = var.clickhouse_operator_namespace
}
