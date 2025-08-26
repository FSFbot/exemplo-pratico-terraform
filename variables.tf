# ================================
# VARIÁVEIS DO TERRAFORM
# Exemplo Prático - Aplicação Web AWS
# ================================

# ================================
# VARIÁVEIS BÁSICAS
# ================================

variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"

  validation {
    condition = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "A região AWS deve estar no formato correto (ex: us-east-1)."
  }
}

variable "project_name" {
  description = "Nome do projeto - usado para nomear recursos"
  type        = string
  default     = "terraform-exemplo"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "O nome do projeto deve conter apenas letras minúsculas, números e hífens."
  }
}

variable "environment" {
  description = "Ambiente de deployment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "O ambiente deve ser 'dev', 'staging' ou 'prod'."
  }
}

# ================================
# VARIÁVEIS DE REDE
# ================================

variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "O CIDR da VPC deve ser um bloco CIDR válido."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block para a subnet pública"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "O CIDR da subnet pública deve ser um bloco CIDR válido."
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR block permitido para acesso SSH (recomendado: seu IP público)"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "O CIDR permitido para SSH deve ser um bloco CIDR válido."
  }
}

# ================================
# VARIÁVEIS DE COMPUTE
# ================================

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"

  validation {
    condition = contains([
      "t2.nano", "t2.micro", "t2.small", "t2.medium", "t2.large",
      "t3.nano", "t3.micro", "t3.small", "t3.medium", "t3.large",
      "t3a.nano", "t3a.micro", "t3a.small", "t3a.medium", "t3a.large"
    ], var.instance_type)
    error_message = "Tipo de instância deve ser um dos tipos válidos da família t2, t3 ou t3a."
  }
}

variable "root_volume_size" {
  description = "Tamanho do volume raiz em GB"
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 100
    error_message = "O tamanho do volume raiz deve estar entre 8 e 100 GB."
  }
}

# ================================
# VARIÁVEIS DE MONITORAMENTO
# ================================

variable "enable_detailed_monitoring" {
  description = "Habilitar monitoramento detalhado do CloudWatch"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Habilitar alarmes do CloudWatch"
  type        = bool
  default     = false
}

# ================================
# VARIÁVEIS OPCIONAIS
# ================================

variable "create_s3_bucket" {
  description = "Criar bucket S3 para logs"
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Número de dias para manter backups"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 365
    error_message = "O período de retenção deve estar entre 1 e 365 dias."
  }
}

# ================================
# VARIÁVEIS DE APLICAÇÃO
# ================================

variable "app_name" {
  description = "Nome da aplicação web"
  type        = string
  default     = "Minha Aplicação Terraform"
}

variable "app_version" {
  description = "Versão da aplicação"
  type        = string
  default     = "1.0.0"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.app_version))
    error_message = "A versão deve seguir o formato semântico (ex: 1.0.0)."
  }
}

variable "enable_ssl" {
  description = "Habilitar SSL/HTTPS (requer certificado)"
  type        = bool
  default     = false
}

# ================================
# VARIÁVEIS DE TAGS
# ================================

variable "additional_tags" {
  description = "Tags adicionais para aplicar a todos os recursos"
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.additional_tags) <= 10
    error_message = "Máximo de 10 tags adicionais são permitidas."
  }
}

variable "cost_center" {
  description = "Centro de custo para billing"
  type        = string
  default     = "education"
}

variable "owner" {
  description = "Proprietário dos recursos"
  type        = string
  default     = "terraform-student"
}

# ================================
# VARIÁVEIS AVANÇADAS
# ================================

variable "enable_termination_protection" {
  description = "Habilitar proteção contra terminação da instância"
  type        = bool
  default     = false
}

variable "enable_ebs_optimization" {
  description = "Habilitar otimização EBS para a instância"
  type        = bool
  default     = false
}

variable "instance_tenancy" {
  description = "Tenancy da instância (default, dedicated, host)"
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated", "host"], var.instance_tenancy)
    error_message = "Tenancy deve ser 'default', 'dedicated' ou 'host'."
  }
}

# ================================
# VARIÁVEIS DE REDE AVANÇADAS
# ================================

variable "enable_nat_gateway" {
  description = "Criar NAT Gateway para subnet privada (custos adicionais)"
  type        = bool
  default     = false
}

variable "enable_vpc_flow_logs" {
  description = "Habilitar VPC Flow Logs"
  type        = bool
  default     = false
}

variable "dns_hostnames" {
  description = "Habilitar DNS hostnames na VPC"
  type        = bool
  default     = true
}

variable "dns_support" {
  description = "Habilitar DNS support na VPC"
  type        = bool
  default     = true
}

# ================================
# VARIÁVEIS DE SEGURANÇA
# ================================

variable "enable_imdsv2" {
  description = "Forçar uso do IMDSv2 (mais seguro)"
  type        = bool
  default     = true
}

variable "enable_ebs_encryption" {
  description = "Habilitar criptografia EBS"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "ID da chave KMS para criptografia (opcional)"
  type        = string
  default     = null
}

# ================================
# VARIÁVEIS DE DESENVOLVIMENTO
# ================================

variable "create_development_resources" {
  description = "Criar recursos adicionais para desenvolvimento"
  type        = bool
  default     = false
}

variable "allow_dev_access" {
  description = "Permitir acesso de desenvolvimento (portas adicionais)"
  type        = bool
  default     = false
}

variable "dev_ports" {
  description = "Portas adicionais para desenvolvimento"
  type        = list(number)
  default     = [3000, 8080, 9000]

  validation {
    condition     = alltrue([for port in var.dev_ports : port > 0 && port < 65536])
    error_message = "Todas as portas devem estar entre 1 e 65535."
  }
}

# ================================
# VARIÁVEIS DE BACKUP
# ================================

variable "enable_automated_backups" {
  description = "Habilitar backups automatizados"
  type        = bool
  default     = false
}

variable "backup_schedule" {
  description = "Cronograma de backup (cron expression)"
  type        = string
  default     = "cron(0 2 * * ? *)"  # Todo dia às 2h da manhã
}

# ================================
# VARIÁVEIS DE NOTIFICAÇÃO
# ================================

variable "notification_email" {
  description = "Email para notificações (alarmes, etc.)"
  type        = string
  default     = null

  validation {
    condition     = var.notification_email == null || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.notification_email))
    error_message = "Email deve ter um formato válido."
  }
}

variable "enable_sns_notifications" {
  description = "Habilitar notificações SNS"
  type        = bool
  default     = false
}

# ================================
# VARIÁVEIS DE PERFORMANCE
# ================================

variable "enable_enhanced_networking" {
  description = "Habilitar enhanced networking (SR-IOV)"
  type        = bool
  default     = false
}

variable "placement_group" {
  description = "Nome do placement group (opcional)"
  type        = string
  default     = null
}

variable "cpu_credits" {
  description = "Configuração de CPU credits para instâncias T2/T3 (standard, unlimited)"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "unlimited"], var.cpu_credits)
    error_message = "CPU credits deve ser 'standard' ou 'unlimited'."
  }
}

