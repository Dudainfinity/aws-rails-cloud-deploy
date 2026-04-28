#!/bin/bash
set -e

echo "🚀 SETUP INICIAL DA EC2"

# 1. Instalar Docker
if ! command -v docker &>/dev/null; then
  echo "📦 Instalando Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker ubuntu
  echo "✅ Docker instalado"
else
  echo "✅ Docker já instalado"
fi

# 2. Clonar repositório
if [ ! -d "/var/www/aws-rails-cloud-deploy/.git" ]; then
  echo "📂 Clonando repositório..."
  sudo mkdir -p /var/www
  sudo chown ubuntu:ubuntu /var/www
  git clone https://github.com/Dudainfinity/aws-rails-cloud-deploy.git /var/www/aws-rails-cloud-deploy
  echo "✅ Repositório clonado"
else
  echo "✅ Repositório já existe"
fi

cd /var/www/aws-rails-cloud-deploy

# 3. Criar .env.production se não existir
if [ ! -f ".env.production" ]; then
  echo "🔑 Criando .env.production..."
  # Substitua o valor abaixo pela sua RAILS_MASTER_KEY real (config/master.key)
  cat > .env.production <<'ENVEOF'
RAILS_MASTER_KEY=f08da0663fa894648563c21fd11829b4
ENVEOF
  echo "✅ .env.production criado"
else
  echo "✅ .env.production já existe"
fi

# 4. Subir containers
echo "🐳 Subindo containers..."
docker compose --env-file .env.production up -d --build

# 5. Aguardar e verificar
echo "⏳ Aguardando 15s..."
sleep 15

echo "📊 Status dos containers:"
docker ps

echo "📜 Logs do web:"
docker logs aws_rails_web --tail=30

echo "🧪 Testando aplicação..."
curl -s -o /dev/null -w "HTTP status: %{http_code}\n" http://localhost || echo "❌ Não respondeu ainda"

echo "🏁 SETUP CONCLUÍDO"
echo "Acesse: http://54.196.48.214"
