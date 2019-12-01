threads_count = ENV.fetch 'RAILS_MAX_THREADS', 5
threads threads_count, threads_count

env = ENV.fetch 'RAILS_ENV', 'development'
environment env
workers ENV.fetch('WORKER', 4).to_i

if env == 'production'
	listen = ENV.fetch('LISTEN') { 'unix://' + File.join(Dir.pwd, 'tmp/sockets/puma.sock') }
	port   = ENV['PORT']
else
	listen = ENV['LISTEN']
	port   = ENV.fetch 'PORT', 3000
end

port(port) if port
bind listen if listen

pidfile File.join Dir.pwd, 'tmp/pids/puma.pid'

plugin :tmp_restart
