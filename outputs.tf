output "vpc_id" {
  description = "ID da VPC dedicada do Kubernetes"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas da VPC"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas da VPC"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "eks_cluster_name" {
  description = "Nome do Cluster AWS EKS"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint HTTPS da API do Kubernetes Control Plane"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Certificado de autoridade do cluster EKS codificado em Base64"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "eks_cluster_security_group_id" {
  description = "ID do Security Group do Cluster EKS"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_security_group_id" {
  description = "ID do Security Group dos Nós Worker EKS"
  value       = aws_security_group.eks_nodes.id
}

output "eks_node_group_arn" {
  description = "ARN do Node Group gerenciado do EKS"
  value       = aws_eks_node_group.main.arn
}

output "api_gateway_endpoint" {
  description = "URL base do AWS API Gateway"
  value       = aws_apigatewayv2_stage.prod.invoke_url
}

output "api_gateway_id" {
  description = "ID do AWS API Gateway"
  value       = aws_apigatewayv2_api.main.id
}

output "kubectl_configure_command" {
  description = "Comando para configurar o kubectl no ambiente local"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}
