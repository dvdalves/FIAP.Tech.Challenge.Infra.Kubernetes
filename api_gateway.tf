# ==============================================================================
# AWS API GATEWAY (HTTP API v2) - ROTEAMENTO CENTRAL & CONTROLE DE ACESSO
# ==============================================================================

resource "aws_apigatewayv2_api" "main" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"
  description   = "API Gateway central para roteamento seguro de trafego para EKS e Serverless"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"]
    allow_headers = ["Content-Type", "Authorization", "X-Requested-With", "traceparent", "tracestate"]
    max_age       = 300
  }

  tags = {
    Name = var.api_gateway_name
  }
}

resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/apigateway/${var.api_gateway_name}"
  retention_in_days = 14

  tags = {
    Name = "${var.api_gateway_name}-access-logs"
  }
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      ip                      = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      httpMethod              = "$context.httpMethod"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      protocol                = "$context.protocol"
      responseLength          = "$context.responseLength"
      integrationLatency      = "$context.integrationLatency"
      responseLatency         = "$context.responseLatency"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }

  tags = {
    Name = "${var.api_gateway_name}-prod-stage"
  }
}

# VPC Link para conectar o API Gateway às portas internas do Kubernetes
resource "aws_apigatewayv2_vpc_link" "eks" {
  name               = "${var.cluster_name}-vpc-link"
  security_group_ids = [aws_security_group.api_gateway.id]
  subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "${var.cluster_name}-vpc-link"
  }
}
