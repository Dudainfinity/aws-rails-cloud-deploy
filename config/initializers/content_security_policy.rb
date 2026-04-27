# Reinicie o servidor ao modificar este arquivo.

# Define uma política de segurança de conteúdo para toda a aplicação.
# Veja o Guia de Segurança do Rails para mais informações:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# Rails.application.configure do
#   config.content_security_policy do |policy|
#     policy.default_src :self, :https
#     policy.font_src    :self, :https, :data
#     policy.img_src     :self, :https, :data
#     policy.object_src  :none
#     policy.script_src  :self, :https
#     policy.style_src   :self, :https
#     # Especifica URI para relatórios de violação
#     # policy.report_uri "/csp-violation-report-endpoint"
#   end
#
#   # Gera nonces de sessão para importmap, scripts inline e estilos inline permitidos.
#   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
#   config.content_security_policy_nonce_directives = %w(script-src style-src)
#
#   # Adiciona automaticamente `nonce` ao `javascript_tag`, `javascript_include_tag` e `stylesheet_link_tag`
#   # se as diretivas correspondentes estiverem em content_security_policy_nonce_directives.
#   # config.content_security_policy_nonce_auto = true
#
#   # Reporta violações sem aplicar a política.
#   # config.content_security_policy_report_only = true
# end
