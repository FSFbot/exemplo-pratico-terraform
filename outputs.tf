# ================================
# OUTPUTS DO TERRAFORM
# Exemplo Prático - Aplicação Web AWS
# ================================

# ================================
# OUTPUTS PRINCIPAIS
# ================================

output "application_url" {
  description = "URL da aplicação web"
  value       = "http://${aws_eip.web_server.public_ip}"
}

output "public_ip" {
  description = "IP público da instância EC2"
  value       = aws_eip.web_server.public_ip
}

output "private_ip" {
  description = "IP privado da instância EC2"
  value       = aws_instance.web_server.private_ip
}

output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.web_server.id
}

# ================================
# OUTPUTS DE CONEXÃO
# ================================

output "ssh_connection" {
  description = "Comando SSH para conectar à instância"
  value       = "ssh -i ${var.project_name}-private-key.pem ec2-user@${aws_eip.web_server.public_ip}"
}

output "key_pair_name" {
  description = "Nome do key pair criado"
  value       = aws_key_pair.main.key_name
}

output "private_key_filename" {
  description = "Nome do arquivo da chave privada"
  value       = "${var.project_name}-private-key.pem"
  sensitive   = false
}

# ================================
# OUTPUTS DE REDE
# ================================

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block da VPC"
  value       = aws_vpc.main.cidr_block
}

output "subnet_id" {
  description = "ID da subnet pública"
  value       = aws_subnet.public.id
}

output "subnet_cidr" {
  description = "CIDR block da subnet pública"
  value       = aws_subnet.public.cidr_block
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "route_table_id" {
  description = "ID da route table pública"
  value       = aws_route_table.public.id
}

# ================================
# OUTPUTS DE SEGURANÇA
# ================================

output "security_group_id" {
  description = "ID do Security Group do servidor web"
  value       = aws_security_group.web_server.id
}

output "security_group_name" {
  description = "Nome do Security Group"
  value       = aws_security_group.web_server.name
}

# ================================
# OUTPUTS DE RECURSOS
# ================================

output "ami_id" {
  description = "ID da AMI utilizada"
  value       = data.aws_ami.amazon_linux.id
}

output "ami_name" {
  description = "Nome da AMI utilizada"
  value       = data.aws_ami.amazon_linux.name
}

output "instance_type" {
  description = "Tipo da instância EC2"
  value       = aws_instance.web_server.instance_type
}

output "availability_zone" {
  description = "Zona de disponibilidade da instância"
  value       = aws_instance.web_server.availability_zone
}

# ================================
# OUTPUTS DE MONITORAMENTO
# ================================

output "cloudwatch_alarm_name" {
  description = "Nome do alarme CloudWatch (se habilitado)"
  value       = var.enable_monitoring ? aws_cloudwatch_metric_alarm.high_cpu[0].alarm_name : null
}

# ================================
# OUTPUTS DE ARMAZENAMENTO
# ================================

output "s3_bucket_name" {
  description = "Nome do bucket S3 para logs (se criado)"
  value       = var.create_s3_bucket ? aws_s3_bucket.logs[0].bucket : null
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3 para logs (se criado)"
  value       = var.create_s3_bucket ? aws_s3_bucket.logs[0].arn : null
}

# ================================
# OUTPUTS DE INFORMAÇÕES DO AMBIENTE
# ================================

output "aws_region" {
  description = "Região AWS utilizada"
  value       = data.aws_region.current.name
}

output "aws_account_id" {
  description = "ID da conta AWS"
  value       = data.aws_caller_identity.current.account_id
}

output "project_name" {
  description = "Nome do projeto"
  value       = var.project_name
}

output "environment" {
  description = "Ambiente de deployment"
  value       = var.environment
}

# ================================
# OUTPUTS DE TAGS
# ================================

output "resource_tags" {
  description = "Tags aplicadas aos recursos"
  value = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedBy   = "Terraform-Exemplo-Pratico"
  }
}

# ================================
# OUTPUTS DE CUSTOS
# ================================

output "estimated_monthly_cost" {
  description = "Custo mensal estimado (USD) - apenas referência"
  value = {
    ec2_instance = var.instance_type == "t2.micro" ? "~$8.50" : "Varia conforme tipo"
    elastic_ip   = "Grátis (se associado)"
    ebs_storage  = "~$${var.root_volume_size * 0.10}"
    data_transfer = "Primeiros 1GB grátis/mês"
    total_estimated = var.instance_type == "t2.micro" ? "~$${8.50 + (var.root_volume_size * 0.10)}" : "Calcular conforme recursos"
  }
}

# ================================
# OUTPUTS DE STATUS
# ================================

output "deployment_status" {
  description = "Status do deployment"
  value = {
    vpc_created      = aws_vpc.main.id != "" ? "✅ Criada" : "❌ Erro"
    instance_running = aws_instance.web_server.instance_state == "running" ? "✅ Executando" : "⏳ Iniciando"
    ip_associated    = aws_eip.web_server.public_ip != "" ? "✅ Associado" : "❌ Erro"
    web_accessible   = "⏳ Verificar em: http://${aws_eip.web_server.public_ip}"
  }
}

# ================================
# OUTPUTS DE PRÓXIMOS PASSOS
# ================================

output "next_steps" {
  description = "Próximos passos após o deployment"
  value = [
    "1. Aguarde 2-3 minutos para a instância inicializar completamente",
    "2. Acesse a aplicação em: http://${aws_eip.web_server.public_ip}",
    "3. Conecte via SSH: ssh -i ${var.project_name}-private-key.pem ec2-user@${aws_eip.web_server.public_ip}",
    "4. Verifique os logs: sudo tail -f /var/log/cloud-init-output.log",
    "5. Para destruir os recursos: terraform destroy"
  ]
}

# ================================
# OUTPUTS DE TROUBLESHOOTING
# ================================

output "troubleshooting" {
  description = "Informações para troubleshooting"
  value = {
    instance_logs    = "sudo tail -f /var/log/cloud-init-output.log"
    nginx_status     = "sudo systemctl status nginx"
    nginx_logs       = "sudo tail -f /var/log/nginx/error.log"
    security_groups  = "Verificar portas 80 e 22 abertas"
    connectivity     = "ping ${aws_eip.web_server.public_ip}"
  }
}

# ================================
# OUTPUTS SENSÍVEIS (CUIDADO!)
# ================================

# Nota: Chave privada não deve ser exposta em outputs em produção
# Este é apenas um exemplo educacional
output "private_key_content" {
  description = "Conteúdo da chave privada (APENAS PARA DESENVOLVIMENTO!)"
  value       = tls_private_key.main.private_key_pem
  sensitive   = true
}

# ================================
# OUTPUTS DE RECURSOS OPCIONAIS
# ================================

output "optional_resources" {
  description = "Status dos recursos opcionais"
  value = {
    s3_bucket_created    = var.create_s3_bucket
    monitoring_enabled   = var.enable_monitoring
    detailed_monitoring  = var.enable_detailed_monitoring
  }
}

# ================================
# OUTPUTS DE CONFIGURAÇÃO
# ================================

output "configuration_summary" {
  description = "Resumo da configuração aplicada"
  value = {
    instance_type        = var.instance_type
    root_volume_size     = "${var.root_volume_size}GB"
    vpc_cidr            = var.vpc_cidr
    public_subnet_cidr  = var.public_subnet_cidr
    ssh_access_from     = var.allowed_ssh_cidr
    ssl_enabled         = var.enable_ssl
    backup_enabled      = var.enable_automated_backups
  }
}

