if redis_url = ENV['REDIS_URL']
  Sidekiq::Workflow.configure url: redis_url
end
