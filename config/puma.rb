threads_count = ENV['RAILS_THREADS']
if threads_count
	min_threads_count = max_threads_count = threads_count
else
	min_threads_count = ENV.fetch 'RAILS_MIN_THREADS', 5
	max_threads_count = ENV.fetch 'RAILS_MAX_THREADS', 5
end
threads min_threads_count, max_threads_count

env = ENV.fetch 'RAILS_ENV', 'development'
environment env

ROOT = Dir.pwd

workers = ENV['RAILS_WORKERS']&.to_i
workers ||= 4 if env == 'production'
workers workers

bind = ENV['RAILS_LISTEN']
port = ENV['RAILS_PORT']

puts env: env
if env == 'production'
	bind ||= 'unix://' + File.join(ROOT, 'tmp/sockets/puma.sock')
else
  bind ||= 'tcp://[::]:3000'
end

puts(port: port, bind: bind)
port port if port
bind bind if bind

pidfile ENV['PUMA_PID'] || File.join(ROOT, 'tmp/pids/puma.pid')

plugin :tmp_restart
