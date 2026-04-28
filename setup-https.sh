#!/bin/bash
set -e

DOMAIN="54-196-48-214.sslip.io"
EMAIL="mariaeduarda.devcloud@gmail.com"

echo "🔐 CONFIGURANDO HTTPS para $DOMAIN"

# 1. Atualizar sistema e instalar dependências
echo "📦 Instalando Nginx e Certbot..."
sudo apt update -y
sudo apt install -y nginx certbot python3-certbot-nginx

# 2. Liberar portas no firewall
sudo ufw allow 'Nginx Full' 2>/dev/null || true
sudo ufw allow 80/tcp 2>/dev/null || true
sudo ufw allow 443/tcp 2>/dev/null || true

# 3. Configurar Nginx como proxy reverso para o Docker
sudo bash -c "cat > /etc/nginx/sites-available/$DOMAIN" <<'NGINXEOF'
server {
    listen 80;
    server_name 54-196-48-214.sslip.io;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host              $http_host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300;
        proxy_connect_timeout 300;
    }
}
NGINXEOF

# 4. Ativar site e remover default
sudo mkdir -p /var/www/certbot
sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/$DOMAIN
sudo rm -f /etc/nginx/sites-enabled/default

# 5. Testar e reiniciar Nginx
echo "🔄 Reiniciando Nginx..."
sudo nginx -t
sudo systemctl restart nginx

# 6. Gerar certificado SSL com Let's Encrypt
echo "🔑 Gerando certificado SSL..."
sudo certbot --nginx \
  -d $DOMAIN \
  --non-interactive \
  --agree-tos \
  -m $EMAIL \
  --redirect

# 7. Reiniciar Docker com nova porta
echo "🐳 Reiniciando containers Docker..."
cd /var/www/aws-rails-cloud-deploy
docker compose --env-file .env.production down
docker compose --env-file .env.production up -d

# 8. Renovação automática
echo "🔁 Configurando renovação automática..."
(sudo crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet && systemctl reload nginx") | sudo crontab -

# 9. Teste final
echo "⏳ Aguardando 10s..."
sleep 10
echo "🧪 Testando HTTPS..."
curl -s -o /dev/null -w "HTTP status: %{http_code}\n" https://$DOMAIN

echo ""
echo "✅ HTTPS configurado com sucesso!"
echo "🌐 Acesse: https://$DOMAIN"
