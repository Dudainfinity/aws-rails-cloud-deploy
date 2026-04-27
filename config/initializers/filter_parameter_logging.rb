# Reinicie o servidor ao modificar este arquivo.

# Configura parâmetros a serem parcialmente correspondidos (ex: passw corresponde a password) e filtrados do arquivo de log.
# Use isso para limitar a divulgação de informações sensíveis.
# Veja a documentação do ActiveSupport::ParameterFilter para notações e comportamentos suportados.
Rails.application.config.filter_parameters += [
  :passw, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc
]
