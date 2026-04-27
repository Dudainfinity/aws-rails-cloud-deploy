# O ambiente de teste é usado exclusivamente para rodar a suite de testes da aplicação.
# Você nunca precisa trabalhar com ele de outra forma. Lembre que o banco de teste
# é um "espaço rascunho" para a suite de testes e é apagado e recriado entre execuções.
# Não dependa dos dados nele!

Rails.application.configure do
  # Configurações aqui têm precedência sobre as de config/application.rb.

  # Durante os testes os arquivos não são monitorados, então o recarregamento não é necessário.
  config.enable_reloading = false

  # O eager loading carrega toda a aplicação. Ao rodar um único teste localmente,
  # geralmente não é necessário e pode deixar a suite de testes mais lenta. Porém,
  # é recomendado habilitá-lo em sistemas de integração contínua para garantir que
  # o eager loading funcione corretamente antes de fazer o deploy.
  config.eager_load = ENV["CI"].present?

  # Configura o servidor de arquivos públicos para testes com cache-control para desempenho.
  config.public_file_server.headers = { "cache-control" => "public, max-age=3600" }

  # Exibe relatórios completos de erros.
  config.consider_all_requests_local = true
  config.cache_store = :null_store

  # Renderiza templates de exceção para exceções resgatáveis e gera erro para as demais.
  config.action_dispatch.show_exceptions = :rescuable

  # Desabilita a proteção contra forgery no ambiente de teste.
  config.action_controller.allow_forgery_protection = false

  # Armazena arquivos enviados no sistema de arquivos local em um diretório temporário.
  config.active_storage.service = :test

  # Diz ao Action Mailer para não entregar e-mails para o mundo real.
  # O método de entrega :test acumula os e-mails enviados no array
  # ActionMailer::Base.deliveries.
  config.action_mailer.delivery_method = :test

  # Define o host a ser usado nos links gerados nos templates de mailer.
  config.action_mailer.default_url_options = { host: "example.com" }

  # Exibe avisos de depreciação no stderr.
  config.active_support.deprecation = :stderr

  # Gera erro para traduções ausentes.
  # config.i18n.raise_on_missing_translations = true

  # Anota a view renderizada com os nomes dos arquivos.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Gera erro quando as opções only/except de um before_action referenciam actions inexistentes.
  config.action_controller.raise_on_missing_callback_actions = true
end
