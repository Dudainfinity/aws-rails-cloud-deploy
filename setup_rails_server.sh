#!/bin/bash
# =============================================================
# Script: setup_rails_server.sh
# Projeto: aws-rails-cloud-deploy
# Descrição: Configura um servidor Ubuntu EC2 para Ruby on Rails
# =============================================================

set -e

echo "============================================="
echo " Iniciando configuração do servidor Rails"
echo "============================================="

# -------------------------------------
# 1. Atualizar o sistema
# -------------------------------------
echo "[1/12] Atualizando o sistema..."
sudo apt-get update -y
sudo apt-get upgrade -y

# -------------------------------------
# 2. Instalar dependências essenciais
# -------------------------------------
echo "[2/12] Instalando dependências Linux..."
sudo apt-get install -y \
  curl \
  wget \
  gnupg2 \
  lsb-release \
  ca-certificates \
  build-essential \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  libpq-dev \
  libsqlite3-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt1-dev \
  libffi-dev \
  autoconf \
  bison \
  libtool \
  software-properties-common

# -------------------------------------
# 3. Instalar Git
# -------------------------------------
echo "[3/12] Instalando Git..."
sudo apt-get install -y git
git --version

# -------------------------------------
# 4. Instalar Nginx
# -------------------------------------
echo "[4/12] Instalando Nginx..."
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# -------------------------------------
# 5. Instalar PostgreSQL
# -------------------------------------
echo "[5/12] Instalando PostgreSQL..."
sudo apt-get install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql

# -------------------------------------
# 6. Instalar Node.js (via NodeSource)
# -------------------------------------
echo "[6/12] Instalando Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version

# -------------------------------------
# 7. Instalar Yarn
# -------------------------------------
echo "[7/12] Instalando Yarn..."
sudo npm install -g yarn
yarn --version

# -------------------------------------
# 8. Instalar rbenv + ruby-build
# -------------------------------------
echo "[8/12] Instalando rbenv..."
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# -------------------------------------
# 9. Instalar Ruby
# -------------------------------------
echo "[9/12] Instalando Ruby 3.2.2 (pode demorar alguns minutos)..."
rbenv install 3.2.2
rbenv global 3.2.2
ruby --version

# -------------------------------------
# 10. Instalar Bundler
# -------------------------------------
echo "[10/12] Instalando Bundler..."
gem install bundler --no-document
bundler --version

# -------------------------------------
# 11. Criar usuário PostgreSQL para a aplicação
# -------------------------------------
echo "[11/12] Criando usuário PostgreSQL 'rails_user'..."
sudo -u postgres psql -c "CREATE USER rails_user WITH PASSWORD 'rails_password';" 2>/dev/null || echo "Usuário já existe."
sudo -u postgres psql -c "ALTER USER rails_user CREATEDB;"

# -------------------------------------
# 12. Criar diretório da aplicação
# -------------------------------------
echo "[12/12] Criando diretório da aplicação..."
sudo mkdir -p /var/www/aws-rails-cloud-deploy
sudo chown -R ubuntu:ubuntu /var/www/aws-rails-cloud-deploy
sudo chmod -R 755 /var/www/aws-rails-cloud-deploy

echo ""
echo "============================================="
echo " Servidor configurado com sucesso!"
echo " Próximo passo: clonar o projeto no GitHub"
echo "============================================="
