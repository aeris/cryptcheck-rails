require 'simpleidn'
require 'cryptcheck'

class CheckWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def key_to_json(key)
		key.nil? ? nil : { type: key.type, size: key.size, rsa_size: key.rsa_equivalent_size }
	end

	def perform(host)
		idn    = SimpleIDN.to_ascii host
		result = begin
			server = self.module::Server.new idn
			grade  = self.module::Grade.new server
			result = {
					key:       key_to_json(server.key),
					dh:        server.dh.collect { |k| key_to_json k },
					protocols: server.supported_protocols,
					ciphers:   server.supported_ciphers.collect { |c| { protocol: c.protocol, name: c.name, size: c.size, dh: key_to_json(c.dh) } },
					score:     {
							rank:    grade.grade,
							details: {
									score:            grade.score,
									protocol:         grade.protocol_score,
									key_exchange:     grade.key_exchange_score,
									cipher_strengths: grade.cipher_strengths_score
							},
							error:   grade.error,
							warning: grade.warning,
							success: grade.success
					}
			}


			self.result server, grade, result
		rescue CryptCheck::Tls::Server::TLSNotAvailableException
			{ no_tls: true }
		end
		Datastore.post self.type, host, result
	end

	protected
	def result(_, _, result)
		result
	end
end
