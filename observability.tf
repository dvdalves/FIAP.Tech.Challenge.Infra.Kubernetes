# ==============================================================================
# MONITORAMENTO & OBSERVABILIDADE (DATADOG, METRICS SERVER & CLOUDWATCH)
# ==============================================================================

# Namespace dedicado para agentes de monitoramento
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      name = "monitoring"
    }
  }

  depends_on = [aws_eks_node_group.main]
}

# 1. Kubernetes Metrics Server (Habilita a coleta de CPU/Memória para HPA)
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

  depends_on = [aws_eks_node_group.main]
}

# 2. Datadog Agent (Monitoramento APM, Traces, Logs JSON e Métricas do Cluster)
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

  # Habilitar APM (Traces e latência das requisições)
  set {
    name  = "datadog.apm.portEnabled"
    value = "true"
  }

  # Habilitar coleta centralizada de Logs estruturados em JSON
  set {
    name  = "datadog.logs.enabled"
    value = "true"
  }

  set {
    name  = "datadog.logs.containerCollectAll"
    value = "true"
  }

  # Habilitar monitoramento de processos e métricas de nós/pods
  set {
    name  = "datadog.processAgent.enabled"
    value = "true"
  }

  set {
    name  = "clusterAgent.enabled"
    value = "true"
  }

  set {
    name  = "clusterAgent.metricsProvider.enabled"
    value = "true"
  }

  depends_on = [aws_eks_node_group.main, kubernetes_namespace.monitoring]
}

# ==============================================================================
# CLOUDWATCH ALARMS (SLA, LATÊNCIA & CONSUMO DE RECURSOS)
# ==============================================================================

# Alarme de latência do API Gateway (> 2000 ms por 2 períodos consecutivos)
resource "aws_cloudwatch_metric_alarm" "api_gateway_high_latency" {
  count               = var.enable_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.api_gateway_name}-HighLatency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "IntegrationLatency"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Average"
  threshold           = 2000
  alarm_description   = "Alarme disparado quando a latencia media da API ultrapassa 2 segundos"

  dimensions = {
    ApiId = aws_apigatewayv2_api.main.id
  }
}

# Alarme de taxa de erros 5XX no API Gateway (> 5 erros por minuto)
resource "aws_cloudwatch_metric_alarm" "api_gateway_5xx_errors" {
  count               = var.enable_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.api_gateway_name}-5XXErrorRate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5XX"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Alarme disparado quando ocorrem mais de 5 falhas 5XX por minuto na API"

  dimensions = {
    ApiId = aws_apigatewayv2_api.main.id
  }
}
