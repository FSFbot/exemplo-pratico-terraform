========================================
INFORMAÇÕES DE CONEXÃO
${project_name}
========================================

🌐 ACESSO À APLICAÇÃO:
   URL: http://${public_ip}
   
📄 PÁGINAS DISPONÍVEIS:
   Principal: http://${public_ip}/
   Info:      http://${public_ip}/info
   Status:    http://${public_ip}/status
   Health:    http://${public_ip}/health

🔐 CONEXÃO SSH:
   Comando: ssh -i ${private_key} ec2-user@${public_ip}
   
   Exemplo de uso:
   chmod 600 ${private_key}
   ssh -i ${private_key} ec2-user@${public_ip}

📊 COMANDOS ÚTEIS NO SERVIDOR:
   Status do sistema:     /usr/local/bin/system-status.sh
   Health check:          /usr/local/bin/health-check.sh
   Status do Nginx:       sudo systemctl status nginx
   Logs do Nginx:         sudo tail -f /var/log/nginx/access.log
   Logs de instalação:    sudo tail -f /var/log/user-data.log

🛠️ TROUBLESHOOTING:
   Se a aplicação não carregar:
   1. Aguarde 2-3 minutos para inicialização completa
   2. Verifique logs: ssh -i ${private_key} ec2-user@${public_ip} "sudo tail -f /var/log/cloud-init-output.log"
   3. Teste conectividade: ping ${public_ip}
   4. Verifique Security Group no console AWS

⚠️  IMPORTANTE:
   - Mantenha o arquivo ${private_key} seguro
   - Execute 'terraform destroy' quando terminar os testes
   - Monitore custos no console AWS

========================================
Gerado automaticamente pelo Terraform
Data: $(date)
========================================

