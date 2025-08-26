# ================================
# TERRAFORM EXEMPLO PRÁTICO
# Aplicação Web Simples na AWS
# ================================

# Configuração do Terraform e Providers
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# Configuração do Provider AWS
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      CreatedBy   = "Terraform-Exemplo-Pratico"
    }
  }
}

# ================================
# DATA SOURCES
# ================================

# Obter dados da região atual
data "aws_region" "current" {}

# Obter dados da conta AWS atual
data "aws_caller_identity" "current" {}

# Obter AMI mais recente do Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Obter zonas de disponibilidade
data "aws_availability_zones" "available" {
  state = "available"
}

# ================================
# NETWORKING
# ================================

# VPC - Virtual Private Cloud
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Subnet Pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
    Type = "Public"
  }
}

# Route Table para Subnet Pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Associação da Route Table com a Subnet Pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ================================
# SECURITY
# ================================

# Security Group para o Servidor Web
resource "aws_security_group" "web_server" {
  name_prefix = "${var.project_name}-web-"
  vpc_id      = aws_vpc.main.id
  description = "Security group para servidor web"

  # Regras de entrada (Ingress)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Regras de saída (Egress)
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ================================
# KEY PAIR
# ================================

# Gerar chave privada TLS
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Criar Key Pair na AWS
resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-keypair"
  public_key = tls_private_key.main.public_key_openssh

  tags = {
    Name = "${var.project_name}-keypair"
  }
}

# Salvar chave privada localmente (para desenvolvimento)
resource "local_file" "private_key" {
  content  = tls_private_key.main.private_key_pem
  filename = "${path.module}/${var.project_name}-private-key.pem"
  
  provisioner "local-exec" {
    command = "chmod 600 ${path.module}/${var.project_name}-private-key.pem"
  }
}

# ================================
# EC2 INSTANCE
# ================================

# Instância EC2 para o Servidor Web
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.web_server.id]
  subnet_id              = aws_subnet.public.id

  # Script de inicialização
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    project_name = var.project_name
    environment  = var.environment
  }))

  # Configurações de armazenamento
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  # Metadados da instância
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Monitoramento detalhado
  monitoring = var.enable_detailed_monitoring

  tags = {
    Name = "${var.project_name}-web-server"
    Type = "WebServer"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ================================
# ELASTIC IP
# ================================

# Elastic IP para a instância
resource "aws_eip" "web_server" {
  instance = aws_instance.web_server.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }

  depends_on = [aws_internet_gateway.main]
}

# ================================
# OUTPUTS LOCAIS
# ================================

# Arquivo com informações de conexão
resource "local_file" "connection_info" {
  content = templatefile("${path.module}/templates/connection_info.tpl", {
    public_ip    = aws_eip.web_server.public_ip
    private_key  = "${var.project_name}-private-key.pem"
    project_name = var.project_name
  })
  filename = "${path.module}/connection_info.txt"
}

# ================================
# RECURSOS OPCIONAIS
# ================================

# CloudWatch Alarm para monitoramento de CPU (opcional)
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }

  tags = {
    Name = "${var.project_name}-cpu-alarm"
  }
}

# S3 Bucket para logs (opcional)
resource "aws_s3_bucket" "logs" {
  count = var.create_s3_bucket ? 1 : 0

  bucket        = "${var.project_name}-logs-${random_id.bucket_suffix[0].hex}"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-logs"
    Purpose     = "Application Logs"
    Environment = var.environment
  }
}

# ID aleatório para o bucket S3
resource "random_id" "bucket_suffix" {
  count = var.create_s3_bucket ? 1 : 0

  byte_length = 4
}

# Configuração de versionamento do bucket S3
resource "aws_s3_bucket_versioning" "logs" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.logs[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configuração de criptografia do bucket S3
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloquear acesso público ao bucket S3
resource "aws_s3_bucket_public_access_block" "logs" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

