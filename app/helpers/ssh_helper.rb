module SshHelper
	COLORS = { green: :success, yellow: :warning, red: :danger, nil => :default  }

	def kex_label(key)
		label key, COLORS[CryptCheck::Ssh::Server::KEX[key]]
	end

	def cipher_label(cipher)
		label cipher, COLORS[CryptCheck::Ssh::Server::ENCRYPTION[cipher]]
	end

	def hmac_label(hmac)
		label hmac, COLORS[CryptCheck::Ssh::Server::HMAC[hmac]]
	end

	def compression_label(compression)
		label compression, COLORS[CryptCheck::Ssh::Server::COMPRESSION[compression]]
	end

	def key_label(key)
		label key, COLORS[CryptCheck::Ssh::Server::KEY[key]]
	end

	private
	def label(name, color)
		"<span class=\"label label-#{color}\">&nbsp;</span>&nbsp;#{name}".html_safe
	end
end
