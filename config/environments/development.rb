require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Configurações aqui têm precedência sobre as de config/application.rb.

  # Faz alterações no código entrarem em vigor imediatamente sem reiniciar o servidor.
  config.enable_reloading = true

  # Não carrega o código antecipadamente na inicialização.
  config.eager_load = false

  # Exibe relatórios completos de erros.
  config.consider_all_requests_local = true

  # Habilita o tempo de resposta do servidor.
  config.server_timing = true

  # Habilita/desabilita o cache do Action Controller. Por padrão está desabilitado.
  # Execute rails dev:cache para alternar o cache do Action Controller.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = { "cache-control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
  end

  # Mude para :null_store para evitar qualquer cache.
  config.cache_store = :memory_store

  # Armazena arquivos enviados no sistema de arquivos local (veja config/storage.yml para opções).
  config.active_storage.service = :local

  # Não se preocupa se o mailer não conseguir enviar.
  config.action_mailer.raise_delivery_errors = false

  # Faz alterações no template entrarem em vigor imediatamente.
  config.action_mailer.perform_caching = false

  # Define localhost para ser usado nos links gerados nos templates de mailer.
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # Exibe avisos de depreciação no logger do Rails.
  config.active_support.deprecation = :log

  # Gera erro ao carregar a página se houver migrações pendentes.
  config.active_record.migration_error = :page_load

  # Destaca o código que disparou queries no banco de dados nos logs.
  config.active_record.verbose_query_logs = true

  # Adiciona comentários com tags de informação de tempo de execução nas queries SQL nos logs.
  config.active_record.query_log_tags_enabled = true

  # Destaca o código que enfileirou jobs em background nos logs.
  config.active_job.verbose_enqueue_logs = true

  # Destaca o código que disparou redirecionamentos nos logs.
  config.action_dispatch.verbose_redirect_logs = true

  # Suprime a saída do logger para requisições de assets.
  config.assets.quiet = true

  # Gera erro para traduções ausentes.
  # config.i18n.raise_on_missing_translations = true

  # Anota a view renderizada com os nomes dos arquivos.
  config.action_view.annotate_rendered_view_with_filenames = true

  # Descomente se quiser permitir acesso ao Action Cable de qualquer origem.
  # config.action_cable.disable_request_forgery_protection = true

  # Gera erro quando as opções only/except de um before_action referenciam actions inexistentes.
  config.action_controller.raise_on_missing_callback_actions = true

  # Aplica autocorreção do RuboCop nos arquivos gerados pelo `bin/rails generate`.
  # config.generators.apply_rubocop_autocorrect_after_generate!
end
