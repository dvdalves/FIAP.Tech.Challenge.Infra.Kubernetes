variable "azure_region" {
  description = "Região do Azure para provisionamento do cluster e VNet"
  type        = string
  default     = "North Central US"
}

variable "resource_group_name" {
  description = "Resource Group da plataforma"
  type        = string
  default     = "fiap-tech-challenge-rg"
}

variable "environment" {
  description = "Ambiente de execução (ex: homolog, production)"
  type        = string
  default     = "production"
}

variable "cluster_name" {
  description = "Nome do cluster Azure Kubernetes Service"
  type        = string
  default     = "oficina-aks-cluster"
}

variable "cluster_version" {
  description = "Versão do Kubernetes control plane no AKS (null para versão padrão da região)"
  type        = string
  default     = null
}

variable "vnet_address_space" {
  description = "Bloco CIDR para a VNet dedicada do Kubernetes"
  type        = string
  default     = "10.0.0.0/16"
}

variable "k8s_node_vm_size" {
  description = "Tamanho das VMs dos nós do AKS"
  type        = string
  default     = "Standard_B2s"
}

variable "node_subnet_prefix" {
  description = "CIDR da subnet dos nós do AKS"
  type        = string
  default     = "10.0.1.0/24"
}

variable "service_subnet_prefix" {
  description = "CIDR da subnet de serviços privados"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "node_desired_size" {
  description = "Quantidade desejada de instâncias worker no Node Group"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Quantidade mínima de instâncias worker no Node Group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Quantidade máxima de instâncias worker no Node Group para escalabilidade elástica"
  type        = number
  default     = 1
}

variable "api_gateway_name" {
  description = "Nome do Azure API Management"
  type        = string
  default     = "oficina-main-apim"
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

variable "enable_monitor_alerts" {
  description = "Habilitar alertas Azure Monitor para latência e erros"
  type        = bool
  default     = true
}

variable "publisher_email" {
  description = "E-mail do publisher do Azure API Management"
  type        = string
  default     = "architecture@example.com"
}
