resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [azurerm_kubernetes_cluster.main]
}

resource "helm_release" "metrics_server" {
  count      = var.enable_metrics_server ? 1 : 0
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.1"
  namespace  = "kube-system"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }

  depends_on = [azurerm_kubernetes_cluster.main]
}

resource "helm_release" "datadog_agent" {
  count      = var.enable_datadog && var.datadog_api_key != "" ? 1 : 0
  name       = "datadog"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  version    = "3.66.0"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set_sensitive {
    name  = "datadog.apiKey"
    value = var.datadog_api_key
  }

  set {
    name  = "datadog.site"
    value = var.datadog_site
  }

  set {
    name  = "datadog.apm.portEnabled"
    value = "true"
  }

  set {
    name  = "datadog.logs.enabled"
    value = "true"
  }

  set {
    name  = "datadog.logs.containerCollectAll"
    value = "true"
  }

  set {
    name  = "clusterAgent.enabled"
    value = "true"
  }

  depends_on = [azurerm_kubernetes_cluster.main, kubernetes_namespace.monitoring]
}

resource "azurerm_monitor_action_group" "platform" {
  name                = "${var.api_gateway_name}-alerts"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "siaesalert"
}

resource "azurerm_monitor_metric_alert" "aks_cpu" {
  count               = var.enable_monitor_alerts ? 1 : 0
  name                = "${var.cluster_name}-high-cpu"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_kubernetes_cluster.main.id]
  description         = "Alerta de consumo elevado de CPU no AKS"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.platform.id
  }
}
