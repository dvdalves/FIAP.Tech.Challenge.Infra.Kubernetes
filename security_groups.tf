# ==============================================================================
# SECURITY GROUPS - CONTROL PLANE, WORKER NODES & API GATEWAY
# ==============================================================================

# Security Group para o Control Plane do EKS
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security Group para comunicacao do Control Plane do EKS"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

# Security Group para os Worker Nodes do EKS
resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security Group para comunicacao entre os Worker Nodes e Control Plane"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Comunicacao interna entre pods e workers"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Trafego vindo do control plane para os pods"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    description     = "Trafego HTTPS do control plane para os webhooks e CNI"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = "${var.cluster_name}-node-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Regra adicional no Control Plane para aceitar trafego HTTPS dos nós worker
resource "aws_security_group_rule" "cluster_ingress_nodes" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  description              = "Permite que os nodes acessem o kube-apiserver"
}

# Security Group para o AWS API Gateway VPC Link
resource "aws_security_group" "api_gateway" {
  name        = "${var.api_gateway_name}-vpc-link-sg"
  description = "Security Group para o AWS API Gateway VPC Link"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.api_gateway_name}-vpc-link-sg"
  }
}
