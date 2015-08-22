Sidekiq.configure_server do |config|
	config.redis = { namespace: :cryptcheck }
end

Sidekiq.configure_client do |config|
	config.redis = { namespace: :cryptcheck }
end
