variable "aws_region" {
  description = "Região da AWS para provisionamento do cluster e VPC"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de execução (ex: homolog, production)"
  type        = string
  default     = "production"
}

variable "cluster_name" {
  description = "Nome do Cluster AWS EKS"
  type        = string
  default     = "oficina-eks-cluster"
}

variable "cluster_version" {
  description = "Versão do Kubernetes control plane no EKS"
  type        = string
  default     = "1.30"
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC dedicada do Kubernetes"
  type        = string
  default     = "10.0.0.0/16"
}

variable "k8s_node_instance_types" {
  description = "Tipos de instâncias EC2 para os worker nodes do cluster EKS"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Quantidade desejada de instâncias worker no Node Group"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Quantidade mínima de instâncias worker no Node Group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Quantidade máxima de instâncias worker no Node Group para escalabilidade elástica"
  type        = number
  default     = 5
}

variable "api_gateway_name" {
  description = "Nome do AWS API Gateway HTTP API"
  type        = string
  default     = "oficina-main-api-gateway"
}

variable "enable_datadog" {
  description = "Flag para habilitar a instalação do Datadog Agent via Helm"
  type        = bool
  default     = false
}

variable "datadog_api_key" {
  description = "API Key da organização Datadog para monitoramento e observabilidade"
  type        = string
  sensitive   = true
  default     = ""
}

variable "datadog_site" {
  description = "Datadog site intake host"
  type        = string
  default     = "datadoghq.com"
}

variable "enable_metrics_server" {
  description = "Instalar o Kubernetes Metrics Server para permitir Horizontal Pod Autoscaler (HPA)"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_alarms" {
  description = "Habilitar alarmes CloudWatch para latência, CPU e memória"
  type        = bool
  default     = true
}
