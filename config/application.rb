require_relative "boot"

require "rails/all"

# Requer as gems listadas no Gemfile, incluindo as limitadas a :test, :development ou :production.
Bundler.require(*Rails.groups)

module AwsRailsCloudDeploy
  class Application < Rails::Application
    # Inicializa os padrões de configuração para a versão do Rails originalmente gerada.
    config.load_defaults 8.1

    # Adicione à lista `ignore` qualquer subdiretório de `lib` que não contenha
    # arquivos `.rb`, ou que não deva ser recarregado ou carregado antecipadamente.
    # Exemplos comuns são `templates`, `generators` ou `middleware`.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuração para a aplicação, engines e railties vai aqui.
    #
    # Estas configurações podem ser sobrescritas em ambientes específicos usando os arquivos
    # em config/environments, que são processados depois.
    #
    # config.time_zone = "Brasilia"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
