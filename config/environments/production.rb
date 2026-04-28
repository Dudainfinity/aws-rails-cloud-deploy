require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Configurações aqui têm precedência sobre as de config/application.rb.

  # O código não é recarregado entre requisições.
  config.enable_reloading = false

  # Carrega o código antecipadamente na inicialização para melhor desempenho e economia de memória (ignorado por tarefas Rake).
  config.eager_load = true

  # Relatórios completos de erros estão desabilitados.
  config.consider_all_requests_local = false

  # Ativa o cache de fragmentos nos templates de view.
  config.action_controller.perform_caching = true

  # Cache de assets com expiração de longo prazo, pois todos têm digest no nome.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Habilita o serviço de imagens, stylesheets e JavaScripts a partir de um servidor de assets.
  # config.asset_host = "http://assets.example.com"

  # Armazena arquivos enviados no sistema de arquivos local (veja config/storage.yml para opções).
  config.active_storage.service = :local

  # Assume que todo acesso à aplicação passa por um reverse proxy que encerra SSL.
  config.assume_ssl = true

  # Força todo acesso à aplicação via SSL, usa Strict-Transport-Security e cookies seguros.
  config.force_ssl = true

  # Ignora redirecionamento de http para https no endpoint de health check padrão.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Loga no STDOUT com o id da requisição atual como tag de log padrão.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Mude para "debug" para logar tudo (incluindo potencialmente informações de identificação pessoal!).
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Evita que health checks encham os logs.
  config.silence_healthcheck_path = "/up"

  # Não loga nenhuma depreciação.
  config.active_support.report_deprecations = false

  # Substitui o cache store padrão em memória por uma alternativa durável.
  config.cache_store = :solid_cache_store

  # Substitui o backend de filas padrão em memória e não-durável para o Active Job.
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Ignora endereços de e-mail inválidos e não gera erros de entrega de e-mail.
  # Defina como true e configure o servidor de e-mail para entrega imediata para gerar erros.
  # config.action_mailer.raise_delivery_errors = false

  # Define o host a ser usado nos links gerados nos templates de mailer.
  config.action_mailer.default_url_options = { host: "example.com" }

  # Especifica o servidor SMTP de saída. Lembre de adicionar credenciais smtp/* via bin/rails credentials:edit.
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }

  # Habilita fallbacks de locale para I18n (faz buscas para qualquer locale
  # retornarem ao I18n.default_locale quando uma tradução não for encontrada).
  config.i18n.fallbacks = true

  # Não despeja o schema após migrações.
  config.active_record.dump_schema_after_migration = false

  # Usa apenas :id para inspeções em produção.
  config.active_record.attributes_for_inspect = [ :id ]

  # Habilita proteção contra DNS rebinding e outros ataques no header `Host`.
  # config.hosts = [
  #   "example.com",     # Permite requisições de example.com
  #   /.*\.example\.com/ # Permite requisições de subdomínios como `www.example.com`
  # ]
  #
  # Ignora proteção contra DNS rebinding no endpoint de health check padrão.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
