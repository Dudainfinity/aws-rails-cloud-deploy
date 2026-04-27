# Este arquivo de configuração será avaliado pelo Puma. Os métodos de nível superior
# invocados aqui fazem parte da DSL de configuração do Puma. Para mais informações
# sobre os métodos da DSL, veja https://puma.io/puma/Puma/DSL.html.
#
# O Puma inicia um número configurável de processos (workers) e cada processo
# atende cada requisição em uma thread de um pool interno de threads.
#
# Você pode controlar o número de workers com ENV["WEB_CONCURRENCY"]. Defina
# este valor apenas quando quiser rodar 2 ou mais workers. O padrão já é 1.
# Você pode definir como `auto` para iniciar automaticamente um worker por
# processador disponível.
#
# O número ideal de threads por worker depende tanto do tempo que a aplicação
# passa aguardando operações de IO quanto de quanto você quer priorizar
# throughput em relação à latência.
#
# Como regra geral, aumentar o número de threads aumenta quanto tráfego um
# processo pode lidar (throughput), mas devido ao Global VM Lock (GVL) do CRuby
# há retornos decrescentes e pode degradar o tempo de resposta (latência) da aplicação.
#
# O padrão é 3 threads, considerado um bom equilíbrio entre
# throughput e latência para a maioria das aplicações Rails.
#
# Qualquer biblioteca que use pool de conexões ou outro pool de recursos deve
# ser configurada para fornecer ao menos tantas conexões quanto o número de
# threads. Isso inclui o parâmetro `pool` do Active Record em `database.yml`.
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Especifica a `porta` que o Puma vai escutar para receber requisições; padrão é 3000.
port ENV.fetch("PORT", 3000)

# Permite que o puma seja reiniciado pelo comando `bin/rails restart`.
plugin :tmp_restart

# Roda o supervisor do Solid Queue dentro do Puma para deployments em servidor único.
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Especifica o arquivo PID. Padrão é tmp/pids/server.pid em desenvolvimento.
# Em outros ambientes, define o arquivo PID apenas se solicitado.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
