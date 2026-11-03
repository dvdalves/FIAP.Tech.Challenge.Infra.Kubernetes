output "resource_group_name" {
  description = "Resource Group da plataforma"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID da VNet dedicada"
  value       = azurerm_virtual_network.main.id
}

output "aks_cluster_name" {
  description = "Nome do cluster AKS"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_fqdn" {
  description = "FQDN do cluster AKS"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "api_management_gateway_url" {
  description = "URL pública do Azure API Management"
  value       = azurerm_api_management.main.gateway_url
}

output "kubectl_configure_command" {
  description = "Comando para configurar o kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
}
