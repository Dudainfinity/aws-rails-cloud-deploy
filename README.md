<div align="center">

# AWS Rails Cloud Deploy

**Aplicação Ruby on Rails em produção na AWS EC2 com Docker, Nginx, PostgreSQL e CI/CD automatizado**

![Ruby](https://img.shields.io/badge/Ruby-3.2.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-8.1-CC0000?style=for-the-badge&logo=rubyonrails&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)

</div>

---

## Sobre o Projeto

Projeto completo de deploy de uma aplicação **Ruby on Rails 8** na **AWS EC2**, cobrindo todas as etapas — do desenvolvimento local até um servidor em produção com HTTPS, banco de dados gerenciado e pipeline de CI/CD automatizado.

O objetivo é demonstrar na prática como configurar uma infraestrutura real de produção utilizando ferramentas modernas e amplamente adotadas no mercado.

---

## Stack de Tecnologias

| Camada | Tecnologia |
|--------|-----------|
| Backend | Ruby on Rails 8.1 |
| Linguagem | Ruby 3.2.2 |
| Banco de Dados | PostgreSQL 16 |
| Servidor de Aplicação | Puma 8 |
| Reverse Proxy | Nginx |
| Containerização | Docker + Docker Compose |
| Infraestrutura | AWS EC2 (Ubuntu 22.04) |
| CI/CD | GitHub Actions |
| SSL/HTTPS | Let's Encrypt + Certbot |

---

## Passo a Passo do Projeto

### 1. Criacao da Aplicacao Rails

Aplicacao gerada com Rails 8 e Ruby 3.2.2, configurada com PostgreSQL e Propshaft para assets. Multi-database setup com bancos separados para cache, queue e cable.

```bash
rails new aws-rails-cloud-deploy --database=postgresql
```

---

### 2. Containerizacao com Docker

**Dockerfile multi-stage** para imagem final enxuta e otimizada:

- Estagio `build` — compila gems, pre-compila assets e bootsnap
- Estagio final — copia apenas o necessario, sem ferramentas de build

Nginx e Puma rodam no mesmo container: Nginx na porta 80 faz proxy reverso para o Puma na porta 3000.

```dockerfile
FROM ruby:3.2.2-slim AS base
# ... build stage
FROM base
# ... final stage com Nginx + Puma
```

---

### 3. Orquestracao com Docker Compose

Dois servicos em rede privada interna:

```yaml
services:
  db:   # PostgreSQL 16 com volume persistente
  web:  # Rails + Nginx, porta 80 exposta
```

Variaveis sensiveis carregadas via `.env.production`. Script `bin/start` prepara o banco antes de subir o servidor.

---

### 4. Infraestrutura na AWS EC2

- Instancia Ubuntu 22.04 na AWS EC2
- Security Group com portas 22 (SSH), 80 (HTTP) e 443 (HTTPS)
- Docker instalado via `get-docker.sh`
- Repositorio clonado em `/var/www/aws-rails-cloud-deploy`
- Script `setup-ec2.sh` automatiza toda a configuracao inicial

---

### 5. Pipeline CI/CD com GitHub Actions

Cada push na branch `main` dispara automaticamente:

```
git push → Lint → Security → Testes → Deploy → Health Check
```

| Etapa | Ferramenta | O que faz |
|-------|-----------|-----------|
| Lint | RuboCop | Verifica estilo do codigo |
| Security | Brakeman + Bundler Audit | Busca vulnerabilidades |
| Testes | Rails Test + PostgreSQL | Roda a suite de testes |
| Deploy | SSH + Docker Compose | Atualiza o servidor |
| Health Check | curl HTTP | Confirma que a app subiu |

---

### 6. HTTPS com Let's Encrypt

- Nginx instalado no host como proxy reverso terminando SSL
- Certificado gratuito via **Let's Encrypt + Certbot**
- Dominio via **sslip.io** (sem necessidade de comprar dominio)
- Renovacao automatica configurada via crontab
- Rails configurado com `force_ssl` e `assume_ssl`

---

## Como Rodar Localmente

**Prerequisitos:** Docker e Docker Compose instalados.

```bash
# Clone o repositorio
git clone https://github.com/Dudainfinity/aws-rails-cloud-deploy.git
cd aws-rails-cloud-deploy

# Configure as variaveis de ambiente
cp .env.example .env.production
# Edite .env.production com sua RAILS_MASTER_KEY

# Suba os containers
docker compose --env-file .env.production up --build

# Acesse em http://localhost:80
```

---

## Deploy em Producao

### Configuracao inicial do servidor

```bash
# Execute o script de setup na EC2
bash setup-ec2.sh
```

### Deploy manual

```bash
ssh -i sua-chave.pem ubuntu@SEU_IP "
  cd /var/www/aws-rails-cloud-deploy &&
  git pull origin main &&
  docker compose --env-file .env.production down &&
  docker compose --env-file .env.production up -d --build
"
```

### Deploy automatico

Basta fazer push para a branch `main` — o GitHub Actions cuida do resto.

```bash
git add .
git commit -m "sua mensagem"
git push origin main
```

---

## Variaveis de Ambiente

Crie um arquivo `.env.production` baseado no `.env.example`:

```env
RAILS_MASTER_KEY=sua_master_key_aqui
DATABASE_HOST=db
DATABASE_USERNAME=rails_user
DATABASE_PASSWORD=rails_password
DATABASE_NAME=aws_rails_cloud_deploy_production
```

---

## Secrets do GitHub Actions

Configure em `Settings → Secrets and variables → Actions`:

| Secret | Descricao |
|--------|-----------|
| `EC2_HOST` | IP publico da instancia EC2 |
| `EC2_USER` | Usuario SSH (ubuntu) |
| `EC2_SSH_KEY` | Conteudo do arquivo `.pem` |

---

## Estrutura do Projeto

```
aws-rails-cloud-deploy/
├── app/                      # Codigo Rails
├── config/
│   ├── deploy.yml            # Configuracao Kamal
│   ├── nginx.conf            # Nginx dentro do container
│   └── environments/
│       └── production.rb     # Configuracoes de producao
├── .github/
│   └── workflows/
│       ├── ci.yml            # Pipeline de testes
│       └── deploy.yml        # Pipeline de deploy
├── Dockerfile                # Build multi-stage
├── docker-compose.yml        # Orquestracao local/producao
├── setup-ec2.sh              # Setup inicial da EC2
├── setup-https.sh            # Configuracao SSL
└── .env.example              # Template de variaveis
```

---

## Autor

Feito por **Maria Eduarda** — [mariaeduarda.devcloud@gmail.com](mailto:mariaeduarda.devcloud@gmail.com)

---

<div align="center">
  <sub>Ruby on Rails + Docker + AWS + GitHub Actions — do zero ao deploy em producao</sub>
</div>
