threads_count = ENV.fetch 'RAILS_MAX_THREADS', 5
threads threads_count, threads_count

env = ENV.fetch 'RAILS_ENV', 'development'
environment env

unless Rails.root
	module Rails
		ROOT = Dir.pwd

		def self.root
			ROOT
		end
	end
end

workers ENV.fetch('WORKER', 4).to_i

if env == 'production'
	listen = ENV.fetch('LISTEN') { 'unix://' + File.join(Rails.root, 'tmp/sockets/puma.sock') }
	port   = ENV['PORT']
else
	listen = ENV['LISTEN']
	port   = ENV.fetch 'PORT', 3000
end

port(port) if port
bind listen if listen

pidfile File.join Rails.root, 'tmp/pids/puma.pid'

plugin :tmp_restart
