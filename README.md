# FIAP Tech Challenge — Infraestrutura Kubernetes

[![CI/CD Pipeline](https://github.com/dvdalves/FIAP.Tech.Challenge.Infra.Kubernetes/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/dvdalves/FIAP.Tech.Challenge.Infra.Kubernetes/actions/workflows/ci-cd.yml)

Repositório Terraform responsável pela infraestrutura de rede, pelo cluster Azure Kubernetes Service (AKS), pelo Azure API Management e pelos componentes de observabilidade do SIAES.

## Sumário

1. [Responsabilidade](#1-responsabilidade)
2. [Tecnologias](#2-tecnologias)
3. [Recursos](#3-recursos)
4. [Como Provisionar](#4-como-provisionar)
5. [CI/CD](#5-cicd)

## 1. Responsabilidade

- Provisionar a VNet e as subnets do ambiente.
- Criar e configurar o cluster AKS.
- Configurar o ponto de entrada pelo Azure API Management.
- Habilitar escalabilidade horizontal com Metrics Server e HPA.
- Integrar métricas, logs e traces com Azure Monitor e Datadog.

## 2. Tecnologias

- Terraform `>= 1.5.0`.
- Azure VNet, NAT Gateway e NSG.
- Azure Kubernetes Service `1.30`.
- Azure API Management.
- Kubernetes Metrics Server e HPA.
- Datadog Agent.
- Azure Monitor.
- GitHub Actions.

## 3. Recursos

Os recursos principais são declarados nos arquivos Terraform:

- Rede privada para os workloads.
- Cluster AKS e node pool com autoscaling.
- API Management para roteamento das APIs.
- Integração opcional com Datadog.
- Alertas e métricas do ambiente Azure.

Os manifestos Kubernetes da aplicação ficam no repositório principal, em [`k8s/`](https://github.com/dvdalves/FIAP.Tech.Challenge/tree/master/k8s).

## 4. Como Provisionar

### Pré-requisitos

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads).
- [Azure CLI](https://learn.microsoft.com/cli/azure/) autenticado com `az login`.
- [kubectl](https://kubernetes.io/docs/tasks/tools/).
- Permissões Azure para criar e alterar os recursos.

### Execução

```bash
cp terraform.tfvars.example terraform.tfvars
```

Preencha o arquivo local com os valores do ambiente. Não publique `terraform.tfvars`, arquivos de estado, chaves do Datadog ou credenciais.

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Após o provisionamento, obtenha as credenciais do cluster:

```bash
az aks get-credentials \
  --resource-group <resource-group> \
  --name <cluster-name>

kubectl get nodes
```

## 5. CI/CD

O workflow [`.github/workflows/ci-cd.yml`](.github/workflows/ci-cd.yml) executa formatação, validação e planejamento do Terraform. O deploy utiliza autenticação federada e secrets configurados no GitHub.
