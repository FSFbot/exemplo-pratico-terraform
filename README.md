# Terraform - Exemplo Prático: Aplicação Web na AWS

Este projeto demonstra como usar o Terraform para criar uma infraestrutura completa na AWS para hospedar uma aplicação web simples. É um exemplo educacional perfeito para estudantes que estão aprendendo Infrastructure as Code (IaC).

## 🎯 Objetivos do Projeto

- Demonstrar conceitos fundamentais do Terraform
- Criar infraestrutura na AWS de forma automatizada
- Mostrar boas práticas de IaC
- Fornecer exemplo prático para estudos

## 🏗️ Arquitetura

Este projeto cria:

```
┌─────────────────────────────────────────────┐
│                   AWS                        │
│  ┌─────────────────────────────────────────┐ │
│  │              VPC                        │ │
│  │  ┌─────────────────────────────────────┐│ │
│  │  │         Public Subnet               ││ │
│  │  │  ┌─────────────────────────────────┐││ │
│  │  │  │        EC2 Instance             │││ │
│  │  │  │     (Aplicação Web)             │││ │
│  │  │  │                                 │││ │
│  │  │  │  - Nginx                        │││ │
│  │  │  │  - Página HTML personalizada    │││ │
│  │  │  └─────────────────────────────────┘││ │
│  │  └─────────────────────────────────────┘│ │
│  │                                         │ │
│  │  Security Group (Firewall)              │ │
│  │  - HTTP (80)                            │ │
│  │  - SSH (22)                             │ │
│  └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

## 📋 Recursos Criados

1. **VPC (Virtual Private Cloud)**: Rede isolada na AWS
2. **Internet Gateway**: Permite acesso à internet
3. **Subnet Pública**: Sub-rede com acesso à internet
4. **Route Table**: Tabela de roteamento
5. **Security Group**: Firewall virtual
6. **Key Pair**: Par de chaves SSH
7. **EC2 Instance**: Servidor virtual
8. **Elastic IP**: IP público estático

## 🚀 Como Usar

### Pré-requisitos

1. **Terraform instalado** (versão 1.0+)
2. **AWS CLI configurado** com credenciais válidas
3. **Conta AWS** com permissões adequadas

### Configuração Inicial

1. **Clone o repositório:**
   ```bash
   git clone <url-do-repositorio>
   cd terraform-exemplo-pratico
   ```

2. **Configure suas credenciais AWS:**
   ```bash
   aws configure
   ```

3. **Copie e personalize as variáveis:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

4. **Edite o arquivo `terraform.tfvars`:**
   ```hcl
   # Região AWS
   aws_region = "us-east-1"
   
   # Nome do projeto
   project_name = "meu-projeto-terraform"
   
   # Ambiente
   environment = "desenvolvimento"
   
   # Tipo de instância EC2
   instance_type = "t2.micro"
   
   # Sua chave SSH pública
   public_key_path = "~/.ssh/id_rsa.pub"
   ```

### Execução

1. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```

2. **Validar a configuração:**
   ```bash
   terraform validate
   ```

3. **Ver o plano de execução:**
   ```bash
   terraform plan
   ```

4. **Aplicar as mudanças:**
   ```bash
   terraform apply
   ```

5. **Acessar a aplicação:**
   - O Terraform mostrará o IP público da instância
   - Acesse `http://<IP_PUBLICO>` no navegador

6. **Destruir a infraestrutura (quando terminar):**
   ```bash
   terraform destroy
   ```

## 📁 Estrutura do Projeto

```
terraform-exemplo-pratico/
├── README.md                 # Este arquivo
├── main.tf                   # Configuração principal
├── variables.tf              # Definição de variáveis
├── outputs.tf                # Saídas do Terraform
├── terraform.tfvars.example  # Exemplo de variáveis
├── user_data.sh             # Script de inicialização da EC2
└── .gitignore               # Arquivos a ignorar no Git
```

## 🔧 Personalização

### Alterando a Aplicação Web

Edite o arquivo `user_data.sh` para personalizar o que será instalado na instância EC2:

```bash
#!/bin/bash
# Seu código personalizado aqui
```

### Modificando Recursos

- **Tipo de instância**: Altere `instance_type` em `terraform.tfvars`
- **Região**: Modifique `aws_region` em `terraform.tfvars`
- **Portas**: Ajuste as regras do Security Group em `main.tf`

## 💰 Custos Estimados

| Recurso | Custo Mensal (us-east-1) |
|---------|--------------------------|
| EC2 t2.micro | ~$8.50 |
| Elastic IP | $0.00 (se associado) |
| **Total** | **~$8.50/mês** |

> **Nota**: Custos podem variar por região e uso. Sempre destrua recursos após testes.

## 🛡️ Segurança

### Boas Práticas Implementadas

- ✅ Security Group restritivo
- ✅ Acesso SSH apenas com chave
- ✅ Subnet pública isolada
- ✅ Tags para organização

### Melhorias Recomendadas para Produção

- 🔒 Usar AWS Secrets Manager para credenciais
- 🔒 Implementar HTTPS com certificado SSL
- 🔒 Configurar backup automático
- 🔒 Usar múltiplas AZs para alta disponibilidade
- 🔒 Implementar monitoramento com CloudWatch

## 🐛 Troubleshooting

### Problemas Comuns

1. **Erro de credenciais AWS**
   ```bash
   aws configure list
   aws sts get-caller-identity
   ```

2. **Instância não acessível**
   - Verificar Security Group
   - Confirmar se Elastic IP foi associado
   - Checar se user_data executou corretamente

3. **Terraform state locked**
   ```bash
   terraform force-unlock <LOCK_ID>
   ```

### Logs e Debugging

```bash
# Logs detalhados
TF_LOG=DEBUG terraform apply

# Verificar estado
terraform state list
terraform state show aws_instance.web_server

# Conectar via SSH
ssh -i ~/.ssh/id_rsa ec2-user@<IP_PUBLICO>
```

## 📚 Conceitos Aprendidos

Ao completar este projeto, você terá aprendido:

- ✅ **Infrastructure as Code (IaC)**: Definir infraestrutura como código
- ✅ **Terraform Basics**: Providers, resources, variables, outputs
- ✅ **AWS Networking**: VPC, subnets, security groups
- ✅ **EC2 Management**: Instâncias, key pairs, user data
- ✅ **State Management**: Como o Terraform gerencia estado
- ✅ **Best Practices**: Organização de código, versionamento

## 🎓 Próximos Passos

1. **Experimente modificações**:
   - Adicione um Load Balancer
   - Crie múltiplas instâncias
   - Implemente um banco de dados RDS

2. **Explore módulos**:
   - Refatore o código usando módulos Terraform
   - Use módulos da comunidade

3. **Implemente CI/CD**:
   - Integre com GitHub Actions
   - Configure Terraform Cloud

4. **Estude outros provedores**:
   - Azure Resource Manager
   - Google Cloud Platform
   - Kubernetes

## 🤝 Contribuições

Este é um projeto educacional. Contribuições são bem-vindas:

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

- 📧 Email: [felipe.sfreitas18@hotmail.com]
- 💬 Issues: Use a aba Issues do GitHub
- 📖 Documentação: [Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**⚠️ Importante**: Sempre execute `terraform destroy` após os testes para evitar custos desnecessários na AWS!

**🎯 Objetivo Educacional**: Este projeto foi criado para fins educacionais e demonstra conceitos fundamentais de Infrastructure as Code com Terraform.

# exemplo-pratico-terraform
