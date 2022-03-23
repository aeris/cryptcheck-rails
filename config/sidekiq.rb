#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
env = ENV.fetch 'RAILS_ENV', 'development'
Bundler.require env

require 'dotenv'
Dotenv.load ".env.#{ENV['RAILS_ENV']}.local", ".env.#{ENV['RAILS_ENV']}", '.env.local', '.env'

class Hash
  def compact
    select { |_, value| !value.nil? }
  end
end

require 'redis'
Redis.exists_returns_integer = true
redis_url                    = ENV.fetch 'REDIS_URL'

require 'sidekiq'
Sidekiq.configure_server { |c| c.redis = { url: redis_url } }
Sidekiq.configure_client { |c| c.redis = { url: redis_url } }
require 'sidekiq/workflow'
redis_url = ENV['REDIS_URL']
Sidekiq::Workflow.configure url: redis_url

require 'cryptcheck'
load File.join __dir__, '../app/jobs/check_job.rb'
load File.join __dir__, '../app/jobs/persist_job.rb'
