# syntax=docker/dockerfile:1
# check=error=true

# Para buildar e rodar manualmente:
# docker build -t aws_rails_cloud_deploy .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<valor de config/master.key> --name aws_rails_cloud_deploy aws_rails_cloud_deploy

ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Instala pacotes base incluindo Nginx
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips nginx postgresql-client && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Define variáveis de ambiente de produção e habilita jemalloc para menor uso de memória.
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Estágio temporário de build para reduzir o tamanho da imagem final
FROM base AS build

# Instala pacotes necessários para compilar gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Instala as gems da aplicação
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile -j 1 --gemfile

# Copia o código da aplicação
COPY . .

# Pré-compila o bootsnap para inicialização mais rápida.
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Pré-compila os assets de produção sem exigir a RAILS_MASTER_KEY secreta
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Estágio final da imagem
FROM base

# Cria usuário não-root para os arquivos da aplicação
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Copia os artefatos buildados: gems e aplicação
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# Configura o Nginx
RUN rm -f /etc/nginx/sites-enabled/default
COPY --from=build /rails/config/nginx.conf /etc/nginx/sites-enabled/rails.conf

# Permissão de execução no script de inicialização
RUN chmod +x /rails/bin/start /rails/bin/docker-entrypoint

EXPOSE 80

CMD ["/rails/bin/start"]
