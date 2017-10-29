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

if env == 'production'
	workers 4
	listen = ENV.fetch('LISTEN') { 'unix://' + File.join(Rails.root, 'tmp/sockets/puma.sock') }
	bind listen
else
	listen = ENV.fetch('PORT') { 3001 }
	port listen
end

pidfile File.join Rails.root, 'tmp/pids/puma.pid'

plugin :tmp_restart
