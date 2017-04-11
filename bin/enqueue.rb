#!/usr/bin/env ruby
ENV['RAILS_ENV'] ||= 'development'
require 'dotenv'
Dotenv.load ".env.#{ENV['RAILS_ENV']}", '.env'

if ENV['RAILS_ENV'] == 'development'
	DIR = File.dirname File.dirname File.expand_path __FILE__
	require File.join DIR, 'config/environment'
	ENV['RAILS_ENV'] = 'test'
	require 'sidekiq/testing/inline'
end

require 'sidekiq'
options      = {
		url:       ENV['REDIS_URL'],
		namespace: :cryptcheck
}
client       = Sidekiq::Client.new Sidekiq::RedisConnection.create options

clazz, *args = ARGV
clazz        += 'Worker'
client.push({ 'class' => clazz, 'args' => args })
