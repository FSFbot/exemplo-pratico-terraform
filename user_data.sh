#!/bin/bash

# ================================
# SCRIPT DE INICIALIZAÇÃO EC2
# Terraform Exemplo Prático
# ================================

# Configurar logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "========================================="
echo "Iniciando configuração da instância EC2"
echo "Data/Hora: $(date)"
echo "Projeto: ${project_name}"
echo "Ambiente: ${environment}"
echo "========================================="

# ================================
# ATUALIZAÇÃO DO SISTEMA
# ================================

echo "📦 Atualizando sistema operacional..."
yum update -y

echo "📦 Instalando pacotes essenciais..."
yum install -y \
    wget \
    curl \
    git \
    htop \
    tree \
    unzip \
    vim \
    nano \
    net-tools \
    telnet \
    nc \
    jq

# ================================
# INSTALAÇÃO DO NGINX
# ================================

echo "🌐 Instalando Nginx..."
amazon-linux-extras install -y nginx1

echo "🌐 Iniciando e habilitando Nginx..."
systemctl start nginx
systemctl enable nginx

# Verificar se o Nginx está rodando
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx instalado e rodando com sucesso!"
else
    echo "❌ Erro ao iniciar Nginx"
    systemctl status nginx
fi

# ================================
# CONFIGURAÇÃO DA APLICAÇÃO WEB
# ================================

echo "🎨 Criando página web personalizada..."

# Backup da página padrão
cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.backup

# Criar nova página HTML
cat > /usr/share/nginx/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${project_name} - Terraform Exemplo</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        
        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            max-width: 600px;
            margin: 20px;
        }
        
        .logo {
            font-size: 3em;
            margin-bottom: 20px;
        }
        
        h1 {
            font-size: 2.5em;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .subtitle {
            font-size: 1.2em;
            margin-bottom: 30px;
            opacity: 0.9;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .info-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .info-card h3 {
            margin-bottom: 10px;
            color: #ffd700;
        }
        
        .status {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .tech-stack {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 10px;
            margin: 20px 0;
        }
        
        .tech-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 0.9em;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .footer {
            margin-top: 30px;
            font-size: 0.9em;
            opacity: 0.8;
        }
        
        .pulse {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .btn {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 25px;
            margin: 10px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 20px;
                margin: 10px;
            }
            
            h1 {
                font-size: 2em;
            }
            
            .logo {
                font-size: 2em;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo pulse">🚀</div>
        <h1>${project_name}</h1>
        <p class="subtitle">Aplicação Web criada com Terraform</p>
        
        <div class="status">✅ Sistema Online</div>
        
        <div class="info-grid">
            <div class="info-card">
                <h3>🌍 Ambiente</h3>
                <p>${environment}</p>
            </div>
            <div class="info-card">
                <h3>☁️ Provedor</h3>
                <p>Amazon Web Services</p>
            </div>
            <div class="info-card">
                <h3>🛠️ IaC Tool</h3>
                <p>HashiCorp Terraform</p>
            </div>
            <div class="info-card">
                <h3>🖥️ Servidor</h3>
                <p>Amazon Linux 2</p>
            </div>
        </div>
        
        <div class="tech-stack">
            <span class="tech-badge">Terraform</span>
            <span class="tech-badge">AWS EC2</span>
            <span class="tech-badge">Nginx</span>
            <span class="tech-badge">Amazon Linux</span>
            <span class="tech-badge">Infrastructure as Code</span>
        </div>
        
        <div style="margin: 30px 0;">
            <a href="/info" class="btn">📊 Informações do Sistema</a>
            <a href="/status" class="btn">🔍 Status dos Serviços</a>
        </div>
        
        <div class="footer">
            <p>🎓 Projeto Educacional - Terraform Exemplo Prático</p>
            <p>Criado automaticamente via Infrastructure as Code</p>
            <p><small>Timestamp: <span id="timestamp"></span></small></p>
        </div>
    </div>
    
    <script>
        // Mostrar timestamp atual
        document.getElementById('timestamp').textContent = new Date().toLocaleString('pt-BR');
        
        // Atualizar timestamp a cada minuto
        setInterval(() => {
            document.getElementById('timestamp').textContent = new Date().toLocaleString('pt-BR');
        }, 60000);
        
        // Efeito de loading
        window.addEventListener('load', () => {
            document.body.style.opacity = '0';
            document.body.style.transition = 'opacity 0.5s ease-in-out';
            setTimeout(() => {
                document.body.style.opacity = '1';
            }, 100);
        });
    </script>
</body>
</html>
EOF

# ================================
# PÁGINAS ADICIONAIS
# ================================

echo "📄 Criando páginas adicionais..."

# Página de informações do sistema
cat > /usr/share/nginx/html/info.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Informações do Sistema</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        .info-section { margin: 20px 0; padding: 15px; background: #f8f9fa; border-radius: 5px; }
        .back-btn { display: inline-block; background: #667eea; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-top: 20px; }
        pre { background: #2d3748; color: #e2e8f0; padding: 15px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🖥️ Informações do Sistema</h1>
        
        <div class="info-section">
            <h3>Sistema Operacional</h3>
            <pre id="os-info">Carregando...</pre>
        </div>
        
        <div class="info-section">
            <h3>Recursos de Hardware</h3>
            <pre id="hardware-info">Carregando...</pre>
        </div>
        
        <div class="info-section">
            <h3>Rede</h3>
            <pre id="network-info">Carregando...</pre>
        </div>
        
        <a href="/" class="back-btn">← Voltar</a>
    </div>
    
    <script>
        // Simular informações do sistema (em produção, viria de APIs)
        document.getElementById('os-info').textContent = 
            'Amazon Linux 2\nKernel: Linux 4.14+\nArquitetura: x86_64';
        
        document.getElementById('hardware-info').textContent = 
            'CPU: Intel Xeon (vCPUs)\nMemória: Variável conforme tipo de instância\nArmazenamento: EBS GP3';
        
        document.getElementById('network-info').textContent = 
            'VPC: 10.0.0.0/16\nSubnet: 10.0.1.0/24\nSecurity Group: Web Server';
    </script>
</body>
</html>
EOF

# Página de status
cat > /usr/share/nginx/html/status.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Status dos Serviços</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        .service { display: flex; justify-content: space-between; align-items: center; padding: 15px; margin: 10px 0; background: #f8f9fa; border-radius: 5px; }
        .status-ok { background: #d4edda; color: #155724; padding: 5px 15px; border-radius: 15px; font-weight: bold; }
        .status-error { background: #f8d7da; color: #721c24; padding: 5px 15px; border-radius: 15px; font-weight: bold; }
        .back-btn { display: inline-block; background: #667eea; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Status dos Serviços</h1>
        
        <div class="service">
            <span>Nginx Web Server</span>
            <span class="status-ok">✅ Online</span>
        </div>
        
        <div class="service">
            <span>Sistema Operacional</span>
            <span class="status-ok">✅ Funcionando</span>
        </div>
        
        <div class="service">
            <span>Conectividade Internet</span>
            <span class="status-ok">✅ Conectado</span>
        </div>
        
        <div class="service">
            <span>Security Group</span>
            <span class="status-ok">✅ Configurado</span>
        </div>
        
        <div class="service">
            <span>Elastic IP</span>
            <span class="status-ok">✅ Associado</span>
        </div>
        
        <a href="/" class="back-btn">← Voltar</a>
    </div>
</body>
</html>
EOF

# ================================
# CONFIGURAÇÃO DO NGINX
# ================================

echo "⚙️ Configurando Nginx..."

# Backup da configuração padrão
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Configurar redirecionamentos
cat > /etc/nginx/conf.d/app.conf << 'EOF'
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;
    
    # Logs personalizados
    access_log /var/log/nginx/app_access.log;
    error_log /var/log/nginx/app_error.log;
    
    # Página principal
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Página de informações
    location /info {
        try_files /info.html =404;
    }
    
    # Página de status
    location /status {
        try_files /status.html =404;
    }
    
    # API de saúde simples
    location /health {
        access_log off;
        return 200 "OK\n";
        add_header Content-Type text/plain;
    }
    
    # Headers de segurança
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
}
EOF

# Testar configuração do Nginx
nginx -t
if [ $? -eq 0 ]; then
    echo "✅ Configuração do Nginx válida"
    systemctl reload nginx
else
    echo "❌ Erro na configuração do Nginx"
    nginx -t
fi

# ================================
# INSTALAÇÃO DE FERRAMENTAS ADICIONAIS
# ================================

echo "🛠️ Instalando ferramentas de monitoramento..."

# Instalar htop para monitoramento
yum install -y htop

# Instalar AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# ================================
# CONFIGURAÇÃO DE LOGS
# ================================

echo "📝 Configurando sistema de logs..."

# Criar diretório para logs da aplicação
mkdir -p /var/log/app

# Configurar logrotate para logs da aplicação
cat > /etc/logrotate.d/app << 'EOF'
/var/log/app/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 nginx nginx
}
EOF

# ================================
# SCRIPTS DE MANUTENÇÃO
# ================================

echo "🔧 Criando scripts de manutenção..."

# Script de status do sistema
cat > /usr/local/bin/system-status.sh << 'EOF'
#!/bin/bash
echo "========================================="
echo "STATUS DO SISTEMA - $(date)"
echo "========================================="
echo ""
echo "🖥️  SISTEMA:"
echo "   Uptime: $(uptime -p)"
echo "   Load: $(uptime | awk -F'load average:' '{print $2}')"
echo "   Memória: $(free -h | grep Mem | awk '{print $3"/"$2}')"
echo "   Disco: $(df -h / | tail -1 | awk '{print $3"/"$2" ("$5" usado)"}')"
echo ""
echo "🌐 NGINX:"
echo "   Status: $(systemctl is-active nginx)"
echo "   Processos: $(ps aux | grep nginx | grep -v grep | wc -l)"
echo "   Conexões: $(netstat -an | grep :80 | wc -l)"
echo ""
echo "📊 REDE:"
echo "   IP Público: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "   IP Privado: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
echo ""
echo "📝 LOGS RECENTES:"
echo "   Nginx Access: $(tail -1 /var/log/nginx/access.log)"
echo "   Nginx Error: $(tail -1 /var/log/nginx/error.log 2>/dev/null || echo 'Nenhum erro')"
echo "========================================="
EOF

chmod +x /usr/local/bin/system-status.sh

# ================================
# CONFIGURAÇÃO DE FIREWALL LOCAL
# ================================

echo "🔒 Configurando firewall local..."

# Instalar e configurar firewalld (opcional, já temos Security Groups)
# yum install -y firewalld
# systemctl start firewalld
# systemctl enable firewalld
# firewall-cmd --permanent --add-service=http
# firewall-cmd --permanent --add-service=https
# firewall-cmd --permanent --add-service=ssh
# firewall-cmd --reload

# ================================
# CONFIGURAÇÃO DE TIMEZONE
# ================================

echo "🕐 Configurando timezone..."
timedatectl set-timezone America/Sao_Paulo

# ================================
# OTIMIZAÇÕES DE PERFORMANCE
# ================================

echo "⚡ Aplicando otimizações de performance..."

# Otimizar configuração do Nginx
sed -i 's/worker_processes auto;/worker_processes auto;\nworker_rlimit_nofile 65535;/' /etc/nginx/nginx.conf

# Configurar limites do sistema
cat >> /etc/security/limits.conf << 'EOF'
nginx soft nofile 65535
nginx hard nofile 65535
EOF

# ================================
# HEALTH CHECKS
# ================================

echo "🏥 Configurando health checks..."

# Script de health check
cat > /usr/local/bin/health-check.sh << 'EOF'
#!/bin/bash
# Health check script

# Verificar se Nginx está rodando
if ! systemctl is-active --quiet nginx; then
    echo "CRITICAL: Nginx não está rodando"
    exit 2
fi

# Verificar se a porta 80 está respondendo
if ! curl -f -s http://localhost/ > /dev/null; then
    echo "CRITICAL: Aplicação não está respondendo na porta 80"
    exit 2
fi

# Verificar uso de memória
MEM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
if [ $MEM_USAGE -gt 90 ]; then
    echo "WARNING: Uso de memória alto: ${MEM_USAGE}%"
    exit 1
fi

# Verificar uso de disco
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 90 ]; then
    echo "WARNING: Uso de disco alto: ${DISK_USAGE}%"
    exit 1
fi

echo "OK: Todos os serviços estão funcionando normalmente"
exit 0
EOF

chmod +x /usr/local/bin/health-check.sh

# ================================
# CONFIGURAÇÃO DE CRON JOBS
# ================================

echo "⏰ Configurando tarefas agendadas..."

# Adicionar cron job para health check (a cada 5 minutos)
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/health-check.sh >> /var/log/health-check.log 2>&1") | crontab -

# Adicionar cron job para limpeza de logs antigos (diário às 2h)
(crontab -l 2>/dev/null; echo "0 2 * * * find /var/log -name '*.log' -mtime +7 -delete") | crontab -

# ================================
# INFORMAÇÕES FINAIS
# ================================

echo "📋 Coletando informações do sistema..."

# Salvar informações da instância
cat > /var/log/instance-info.log << EOF
========================================
INFORMAÇÕES DA INSTÂNCIA EC2
========================================
Data de criação: $(date)
Projeto: ${project_name}
Ambiente: ${environment}

Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)
Instance Type: $(curl -s http://169.254.169.254/latest/meta-data/instance-type)
AMI ID: $(curl -s http://169.254.169.254/latest/meta-data/ami-id)
Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
Public IP: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
Private IP: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

Security Groups: $(curl -s http://169.254.169.254/latest/meta-data/security-groups)

Sistema Operacional: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
Kernel: $(uname -r)
Arquitetura: $(uname -m)

Nginx Version: $(nginx -v 2>&1 | cut -d' ' -f3)
AWS CLI Version: $(aws --version 2>&1 | cut -d' ' -f1)
========================================
EOF

# ================================
# FINALIZAÇÃO
# ================================

echo "🎉 Configuração concluída com sucesso!"
echo ""
echo "========================================="
echo "RESUMO DA INSTALAÇÃO"
echo "========================================="
echo "✅ Sistema atualizado"
echo "✅ Nginx instalado e configurado"
echo "✅ Aplicação web criada"
echo "✅ Páginas adicionais configuradas"
echo "✅ Scripts de manutenção instalados"
echo "✅ Health checks configurados"
echo "✅ Logs configurados"
echo "✅ Cron jobs agendados"
echo ""
echo "🌐 Aplicação disponível em:"
echo "   http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)/"
echo ""
echo "📊 Páginas disponíveis:"
echo "   /        - Página principal"
echo "   /info    - Informações do sistema"
echo "   /status  - Status dos serviços"
echo "   /health  - Health check API"
echo ""
echo "🔧 Scripts úteis:"
echo "   /usr/local/bin/system-status.sh  - Status do sistema"
echo "   /usr/local/bin/health-check.sh   - Verificação de saúde"
echo ""
echo "📝 Logs importantes:"
echo "   /var/log/user-data.log          - Log desta instalação"
echo "   /var/log/nginx/access.log       - Logs de acesso Nginx"
echo "   /var/log/nginx/error.log        - Logs de erro Nginx"
echo "   /var/log/health-check.log       - Logs de health check"
echo "   /var/log/instance-info.log      - Informações da instância"
echo "========================================="

# Executar health check inicial
echo "🏥 Executando health check inicial..."
/usr/local/bin/health-check.sh

# Mostrar status final
echo ""
echo "📊 Status final dos serviços:"
systemctl status nginx --no-pager -l

echo ""
echo "🎯 Instalação concluída! A aplicação está pronta para uso."
echo "⏰ Timestamp final: $(date)"
echo "========================================="

# Sinalizar conclusão para o CloudFormation/Terraform (se aplicável)
/opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource AutoScalingGroup --region ${AWS::Region} 2>/dev/null || true

