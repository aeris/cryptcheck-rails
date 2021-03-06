Rails.application.config.tap do |config|
	config.openssl_ciphers = JSON.parse File.read File.join Rails.root, 'config/openssl-ciphers.json'
	config.openssl_ciphers.merge! config.openssl_ciphers.invert

	config.user_agents_ciphers = JSON.parse File.read File.join Rails.root, 'config/user-agents-ciphers.json'
end
